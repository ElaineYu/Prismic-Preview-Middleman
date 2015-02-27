require 'prismic'
Dir["source/config_modules/*"].each {|file| require file }
helpers ViewHelpers
helpers PrismicHelpers
# PRISMIC
helpers FaqPrismic
faq_prismic
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


# ENV = YAML::load(File.open('aws.yml'))

# Configuration code for Middleman AWS S3 Sync
activate :s3_sync do |s3_sync|
  s3_sync.bucket                     = 'staging-fove' # The name of the S3 bucket you are targetting. This is globally unique.
  s3_sync.region                     = 'us-west-1'     # The AWS region for your bucket.
  s3_sync.aws_access_key_id          = ENV['AWS_ACCESS_KEY_ID']
  s3_sync.aws_secret_access_key      = ENV['AWS_SECRET_KEY']
  #s3_sync.delete                     = true # We delete stray files by default.
  #s3_sync.after_build                = true # We do not chain after the build step by default.
end

# CloudFront cache invalidation
activate :cloudfront do |cf|
  cf.access_key_id                   = ENV['AWS_ACCESS_KEY_ID']
  cf.secret_access_key               = ENV['AWS_SECRET_KEY']
  cf.distribution_id                 = ENV['STAGING_CLOUDFRONT_DISTRIBUTION_ID']
  cf.filter                          = /\.html$/i
  #cf.after_build                     = false  # default is false
end

after_s3_sync do |files_by_status|
  invalidate files_by_status[:updated]
end


# PRISMIC PREVIEW EXPERIMENT

  ######## CREATE A PREVIEW ENDPOINT ##############

  # This is a special URL of your website that prismic will call to request a preview, passing the preview token in the query string. You will configure this URL in the settings of your repository.
  # When requested this endpoint must:
  # Retrieve the preview token looking at the token parameter in the query string.
  # Call the prismic.io development kit with this token and the linkResolver to retrieve the best URL for this preview.
  # Store the preview token in the io.prismic.preview cookie (typically for 30 minutes max, since the token will expire after that), and redirect to the given URL.

require 'sinatra'

class PrismicRuby < Sinatra::Base
  get '/preview' do
    # preview_token = params[:token]
    # redirect_url = api.preview_session(preview_token, link_resolver(), '/')
    # cookies[Prismic::PREVIEW_COOKIE] = { value: preview_token, expires: 30.minutes.from_now }
    puts "////////////////////////////////////"
    puts "Preview endpoint is working"
    "Preview endpoint is working"
    puts "////////////////////////////////////"
    # redirect '/'
  end

  # If something goes wrong, it could be because of an invalid preview token
  def clearcookies
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

end
