class SearchesController < ApplicationController
  after_action :track_action, only: :typeahead_search

  def typeahead_search
    @typeahead_query = params[:q]
    cookies.encrypted[:search_term] = @typeahead_query

    render json: formatted_results_typeahead.to_json
  end

  def main_search
    @main_query = params[:q]

    cookies.encrypted[:search_term] = @main_query

    @search_result_props = formatted_results_main
    render :show
  end

  private

  def formatted_results_typeahead
    results = Episode.typeahead_search(@typeahead_query)

    results.each_with_index.map { |result, index| { "id" => index+1 }.merge(result.fetch("_source")) }
  end

  def formatted_results_main
    results = Episode.main_search(@main_query)

    results.map { |result| result.fetch("_source") }
  end

  def track_action
    ahoy.track "Search", request.path_parameters.merge(search_term: @query)
  end
end
