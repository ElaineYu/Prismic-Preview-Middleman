require 'prismic'
Dir["source/config_modules/*"].each {|file| require file }
helpers ViewHelpers
helpers PrismicHelpers
# PRISMIC
helpers FaqPrismic
faq_prismic

helpers MainArticlePrismic
main_article_prismic
###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Create pretty urls
activate :directory_indexes

# Sprockets
activate :sprockets

# Middleman autoprefixer
activate :autoprefixer

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'assets/stylesheets'

set :js_dir, 'assets/javascripts'

set :images_dir, 'assets/images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

# PRISMIC PREVIEW EXPERIMENT

######## CREATE A PREVIEW ENDPOINT ##############

# This is a special URL of your website that prismic will call to request a preview, passing the preview token in the query string. You will configure this URL in the settings of your repository.
# When requested this endpoint must:
# Retrieve the preview token looking at the token parameter in the query string.
# Call the prismic.io development kit with this token and the linkResolver to retrieve the best URL for this preview.
# Store the preview token in the io.prismic.preview cookie (typically for 30 minutes max, since the token will expire after that), and redirect to the given URL.

require 'sinatra'
require 'sinatra/base'
require 'sinatra/contrib/all'
require "sinatra/cookies"
require 'active_support'
require 'active_support/all'
require 'prismic'

map "/preview" do
  run PrismicRuby
end

class PrismicRuby < Sinatra::Base
  register Sinatra::Contrib
  get '' do
    api = Prismic.api('https://middleman-sandbox.cdn.prismic.io/api')
    cookies.delete Prismic::PREVIEW_COOKIE
    preview_token = params[:token]
    puts "//////////////////////"
    puts "Preview Token"
    puts preview_token.inspect
    puts "//////////////////////"
    redirect_url = api.preview_session(preview_token, link_resolver(maybe_ref), '/')
    cookies[Prismic::PREVIEW_COOKIE] = { value: preview_token, expires: 30.minutes.from_now, http_only: false }
    puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    puts "Inspect Cookies"
    puts cookies.inspect
    # puts cookies[Prismic::PREVIEW_COOKIE].inspect
    puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    redirect redirect_url
  end

  # For a given document, describes its URL on your front-office.
  # You really should edit this method, so that it supports all the document types your users might link to.
  #
  # Beware: doc is not a Prismic::Document, but a Prismic::Fragments::DocumentLink,
  # containing only the information you already have without querying more (see DocumentLink documentation)
  # If something goes wrong, it could be because of an invalid preview token
  def link_resolver(maybe_ref)
    @link_resolver ||= Prismic::LinkResolver.new(maybe_ref) {|doc_link|
      puts "////////////////////////////////"
      puts "Doc Link"
      puts doc_link.type.inspect
      puts doc_link.inspect
      puts "////////////////////////////////"
      return '#' if doc_link.broken?
      case doc_link.type
      when "main-article"
        "http://localhost:4567"
      when "faq-category"
        # "http://localhost:4567/#{doc_link.id}/#{doc_link.slug}"
        # "http://localhost:4567/#{doc_link.slug}/"
        "http://localhost:4567/faq"
      else
        raise "link_resolver doesn't know how to write URLs for #{doc_link.type} type."
      end
      # maybe_ref is not expected by document path, so it appends a ?ref=maybe_ref to the URL;
      # since maybe_ref is nil when on master ref, it appends nothing.
      # You should do the same for every path method used here in the link_resolver and elsewhere in your app,
      # so links propagate the ref id when you're previewing future content releases.
    }
  end

  #Helpers
  def maybe_ref
    @maybe_ref ||= (params[:ref].blank? ? nil : params[:ref])
  end

  def clearcookies
    puts "Clear Cookies"
    cookies.delete Prismic::PREVIEW_COOKIE
    redirect '/'
  end

  # Setting @ref as the actual ref id being queried, even if it's the master ref.
  # To be used to call the API, for instance: api.form('everything').submit(ref)
  def ref
    @ref ||= preview_ref || api.master_ref.ref
  end

  def preview_ref
    if request.cookies.has_key?(Prismic::PREVIEW_COOKIE)
      request.cookies[Prismic::PREVIEW_COOKIE]
    else
      nil
    end

  end

  #Open API access visibility for now
  def api
    @api ||= Prismic.api('https://middleman-sandbox.cdn.prismic.io/api') || PrismicService.init_api
  end

end
