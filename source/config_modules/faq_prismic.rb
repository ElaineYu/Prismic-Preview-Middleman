require 'source/config_modules/prismic_helpers'
module FaqPrismic
  def faq_prismic
    api
    response_faq = api
     .form('everything')
     .query('[[:d = at(document.type, "faq-category")]]')
     .orderings('[my.faq-category.order]')
     .submit(api.master_ref)

    @faq = response_faq.results
    puts @faq.inspect
    @faq.each do |doc|
      puts "hey"
      puts doc["faq-category.title"].value
      puts doc["faq-category.order"].value
      doc["faq-category.qa"].group_documents.each do |segment|
        puts segment.fragments["question"].value
        puts segment.fragments["answer"].value
      end
    end
  end
end