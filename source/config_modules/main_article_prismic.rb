require 'source/config_modules/prismic_helpers'
module MainArticlePrismic
  def main_article_prismic
    api
    response_main_article = api
     .form('everything')
     .query('[[:d = at(document.type, "main-article")]]')
     .submit(api.master_ref)

    @main_article = response_main_article.results[0]
    @main_article_title = @main_article["main-article.title"].blocks[0].text
    @main_article_description = @main_article["main-article.description"].blocks[0].text
    @main_article_image_url = @main_article["main-article.image"].main.url
  end
end