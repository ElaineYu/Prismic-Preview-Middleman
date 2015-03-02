module PrismicHelpers

  private
  # Easier access and initialization of the Prismic::API object.
  def api
    @api ||= Prismic.api('https://middleman-sandbox.cdn.prismic.io/api') || PrismicService.init_api
  end

end