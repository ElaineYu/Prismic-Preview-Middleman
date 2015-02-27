module PrismicHelpers

  # For a given document, describes its URL on your front-office.
  # You really should edit this method, so that it supports all the document types your users might link to.
  #
  # Beware: doc is not a Prismic::Document, but a Prismic::Fragments::DocumentLink,
  # containing only the information you already have without querying more (see DocumentLink documentation)
  def link_resolver()
    @link_resolver ||= Prismic::LinkResolver.new(nil) {|doc|
      document_path(id: doc.id, slug: doc.slug)
      # maybe_ref is not expected by document path, so it appends a ?ref=maybe_ref to the URL;
      # since maybe_ref is nil when on master ref, it appends nothing.
      # You should do the same for every path method used here in the link_resolver and elsewhere in your app,
      # so links propagate the ref id when you're previewing future content releases.
    }
  end

  private
  # Easier access and initialization of the Prismic::API object.
  def api
    @api ||= Prismic.api('https://fove.prismic.io/api') || PrismicService.init_api
  end


  # Return the set reference
  def maybe_ref
    @maybe_ref ||= (params[:ref].blank? ? nil : params[:ref])
  end

 # For writers to preview a draft with the real layout
  # def preview
  #   preview_token = params[:token]
  #   redirect_url = api.preview_session(preview_token, link_resolver(), '/')
  #   cookies[Prismic::PREVIEW_COOKIE] = { value: preview_token, expires: 30.minutes.from_now }
  #   redirect_to '/'
  # end

end