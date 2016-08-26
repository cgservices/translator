module Translator
  class TranslationsController < ApplicationController
    before_filter :auth
    layout Translator.layout_name

    def translator_keys
      # section = params[:key].present? && params[:key] + '.'
      params[:group] = "all"
      # @sections = Translator.keys_for_strings(:group => params[:group]).map {|k| k = k.scan(/^[a-zA-Z0-9\-_]*\./)[0]; k ? k.gsub('.', '') : false}.select{|k| k}.uniq.sort
      # @groups = ["framework", "application", "deleted"]
      Translator.keys_for_strings(:group => params[:group])
    end

    def keys
      @keys = filter(translator_keys).sort
    end

    def index
      @keys = filter(translator_keys)
      @keys = paginate(@keys)
    end

    def create
      Translator.current_store[params[:key]] = params[:value]
      redirect_to :back unless request.xhr?
    end

    def destroy
      key = params[:id].gsub('-','.')
      Translator.locales.each do |locale|
        Translator.current_store.destroy_entry(locale.to_s + '.' + key)
      end
      redirect_to :back unless request.xhr?
    end

    private

    def auth
      true
      #Translator.auth_handler.bind(self).call if Translator.auth_handler.is_a? Proc
    end

    def paginate(collection)
      @page = params[:page].to_i
      @page = 1 if @page == 0
      @total_pages = (collection.count / 25.0).ceil
      collection[(@page-1)*25..@page*25]
    end

    def filter(collection)
      if params[:key_exclude].present?
        collection = collection.select { |k| !params[:key_exclude].split.any? { |s| k.include?(s) } }
      end

      if params[:key]
        collection = collection.select { |k| k.include?(params[:key]) }
      end

      if params[:search]
        collection = collection.select { |k|
          Translator.locales.any? { |locale| I18n.translate("#{k}", :locale => locale).to_s.downcase.include?(params[:search].downcase) || k.to_s.downcase.include?(params[:search].downcase)}
        }
      end

      if params[:translated] == '2'
        collection = collection.select { |k|
          translations = []
          Translator.locales.each { |locale| begin translations << I18n.backend.translate(locale, "#{k}") rescue nil; end }
          translations.uniq.length == 1
        }
      end

      if params[:translated] == '1'
        collection = collection.select { |k|
          Translator.locales.all? { |locale| (begin I18n.backend.translate(locale, "#{k}") rescue nil; end).present? }
        }
      end

      if params[:translated] == '0'
        collection = collection.select { |k|
          Translator.locales.any? { |locale| (begin I18n.backend.translate(locale, "#{k}") rescue nil; end).blank? }
        }
      end
      collection
    end
  end
end
