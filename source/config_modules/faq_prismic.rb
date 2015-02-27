require 'source/config_modules/prismic_helpers'
module FaqPrismic
  def faq_prismic
    api
    response_faq = api
     .form('everything')
     .query('[[:d = at(document.type, "faq")]]')
     .orderings('[my.faq.order]')
     .submit(api.master_ref)

    @faq = response_faq.results
    puts @faq.inspect
    @faq.each do |doc|
        puts "hey"
      puts doc["faq.title"].value
      puts doc["faq.order"].value
      doc["faq.qa"].group_documents.each do |segment|
        puts segment.fragments["question"].value
        puts segment.fragments["answer"].value
      end
    end
  end
end