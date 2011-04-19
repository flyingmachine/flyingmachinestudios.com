require "compass"
require "susy"

module Nesta
  class App
    configure do
      # configure compass
      Compass.configuration do |config|
        config.project_path = self.root
        config.sass_dir = File.join("local", "views", "css")
        config.output_style = :nested
      end
    end

    helpers do
      def set_common_variables
        @menu_items = Nesta::Menu.for_path('/')
        @site_title = Nesta::Config.title
        set_from_config(:title, :subtitle, :google_analytics_code)
        @heading = @title
        @recent_articles = Page.find_articles[0..7]
      end
    end

    get "/css/:sheet.css" do
      content_type "text/css", :charset => "utf-8"
      file = File.join("css", params[:sheet]).to_sym
      cache scss(file, Compass.sass_engine_options)
    end    
  end
end

require File.join(Nesta::Config.attachment_path, "source", "custom_tags")

module Nesta
  class Page
    def additional_stylesheets
      metadata("additional_stylesheets") ? metadata("additional_stylesheets").split : []
    end
  end
end