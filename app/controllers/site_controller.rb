class SiteController < ApplicationController
  layout "site"
  layout :map_layout, :only => [:index, :export]

  before_action :authorize_web
  before_action :set_locale
  before_action :redirect_browse_params, :only => :index
  before_action :redirect_map_params, :only => [:index, :edit, :export]
  before_action :require_oauth, :only => [:index]
  before_action :require_user, :only => [:id]
  before_action :update_totp, :only => [:index]

  authorize_resource :class => false

  content_security_policy(:only => :edit) do |policy|
    policy.frame_src(*policy.frame_src, :blob)
  end

  content_security_policy(:only => :id) do |policy|
    policy.connect_src("*")
    policy.img_src(*policy.img_src, "*", :blob)
    policy.script_src(*policy.script_src, :unsafe_eval)
    policy.style_src(*policy.style_src, :unsafe_inline)
  end

  def index
    # Don't use ip-based lookup
    session[:location] ||= nil
  end

  def permalink
    lon, lat, zoom = ShortLink.decode(params[:code])
    new_params = params.except(:host, :controller, :action, :code, :lon, :lat, :zoom, :layers, :node, :way, :relation, :changeset)

    if new_params.key? :m
      new_params.delete :m
      new_params[:mlat] = lat
      new_params[:mlon] = lon
    end

    new_params[:anchor] = "map=#{zoom}/#{lat}/#{lon}"
    new_params[:anchor] += "&layers=#{params[:layers]}" if params.key? :layers

    options = new_params.to_unsafe_h.to_options

    path = if params.key? :node
             node_path(params[:node], options)
           elsif params.key? :way
             way_path(params[:way], options)
           elsif params.key? :relation
             relation_path(params[:relation], options)
           elsif params.key? :changeset
             changeset_path(params[:changeset], options)
           else
             root_url(options)
           end

    redirect_to path
  end

  def edit
    editor = preferred_editor

    if editor == "remote"
      require_oauth
      render :action => :index, :layout => map_layout
      return
    else
      require_user
    end

    begin
      if params[:node]
        bbox = Node.visible.find(params[:node]).bbox.to_unscaled
        @lat = bbox.centre_lat
        @lon = bbox.centre_lon
        @zoom = 18
      elsif params[:way]
        bbox = Way.visible.find(params[:way]).bbox.to_unscaled
        @lat = bbox.centre_lat
        @lon = bbox.centre_lon
        @zoom = 17
      elsif params[:note]
        note = Note.visible.find(params[:note])
        @lat = note.lat
        @lon = note.lon
        @zoom = 17
      elsif params[:gpx] && current_user
        trace = Trace.visible_to(current_user).find(params[:gpx])
        @lat = trace.latitude
        @lon = trace.longitude
        @zoom = 16
      end
    rescue ActiveRecord::RecordNotFound
      # don't try and derive a location from a missing/deleted object
    end

    if api_status != "online"
      flash.now[:warning] = { :partial => "layouts/offline_flash" }
    elsif current_user && !current_user.data_public?
      flash.now[:warning] = { :partial => "not_public_flash" }
    else
      @enable_editor = true
    end
  end

  def copyright
    @title = t ".title"
    @locale = params[:copyright_locale] || I18n.locale
  end

  def welcome; end

  def help; end

  def about
    @locale = params[:about_locale] || I18n.locale
  end

  def communities
    @local_chapters = Community.where(:type => "osm-lc").where.not(:id => "OSMF")
  end

  def export; end

  def offline
    flash.now[:warning] = { :partial => "layouts/offline_flash" }
    render :html => nil, :layout => true
  end

  def preview
    if params[:text].blank?
      flash.now[:warning] = t("layouts.nothing_to_preview")
      render :partial => "layouts/flash"
    else
      render :html => RichText.new(params[:type], params[:text]).to_html
    end
  end

  def id
    render :layout => false
  end

  private

  def redirect_browse_params
    if params[:node]
      redirect_to node_path(params[:node])
    elsif params[:way]
      redirect_to way_path(params[:way])
    elsif params[:relation]
      redirect_to relation_path(params[:relation])
    elsif params[:note]
      redirect_to note_path(params[:note])
    elsif params[:query]
      redirect_to search_path(:query => params[:query])
    end
  end

  def redirect_map_params
    anchor = []

    anchor << "map=#{params.delete(:zoom) || 5}/#{params.delete(:lat)}/#{params.delete(:lon)}" if params[:lat] && params[:lon]

    if params[:layers]
      anchor << "layers=#{params.delete(:layers)}"
    elsif params.delete(:notes) == "yes"
      anchor << "layers=N"
    end

    redirect_to params.to_unsafe_h.merge(:only_path => true, :anchor => anchor.join("&")) if anchor.present?
  end
end
