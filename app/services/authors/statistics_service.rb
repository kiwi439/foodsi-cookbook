module Authors
  class StatisticsService
    ParamsError = Class.new(StandardError)

    PERMITTED_GROUP_BY = %w[category week month]

    def initialize(author_id:, group_by:)
      @author_id = author_id
      @group_by = group_by
      validate_group_by!
    end

    def call
      sql_part = build_SQL_part
      raw_statistics = get_raw_statistics(sql_part: sql_part)
      transform_statistics(statistics: raw_statistics)
    end

    private

    def validate_group_by!
      raise ParamsError, "group_by can't be '#{@group_by}', permitted values: #{PERMITTED_GROUP_BY.join(', ')}" unless PERMITTED_GROUP_BY.include?(@group_by)
    end

    def build_SQL_part
      sql_part = {}

      case @group_by
      when 'category'
        sql_part[:group_clause] = 'categories.name'
        sql_part[:select_clause] = 'categories.name AS group_value'
      when 'week'
        sql_part[:group_clause]  = "DATE(recipes.created_at, 'weekday 1', '-7 days')"
        sql_part[:select_clause] = "DATE(recipes.created_at, 'weekday 1', '-7 days') AS group_value"
      when 'month'
        sql_part[:group_clause] = "DATE(recipes.created_at, 'start of month')"
        sql_part[:select_clause] = "DATE(recipes.created_at, 'start of month') AS group_value"
      end

      sql_part
    end

    def get_raw_statistics(sql_part:)
      Recipe
        .left_joins(:categories, :likes)
        .where(author_id: @author_id)
        .group(sql_part[:group_clause])
        .select(
          'recipes.author_id AS id',
          sql_part[:select_clause],
          "'#{@group_by}' AS grouped_by",
          'COUNT(DISTINCT recipes.id) AS recipes_quantity',
          'COUNT(likes.id) AS likes_quantity'
        )
    end

    def transform_statistics(statistics:)
      statistics.each do |statistic|
        if @group_by == 'week'
          start_date = Date.parse(statistic[:group_value])
          end_date   = start_date + 6
          range = "#{start_date.strftime('%d.%m.%Y')} - #{end_date.strftime('%d.%m.%Y')}"

          statistic[:group_value] = range
        elsif @group_by == 'month'
          start_date = Date.parse(statistic[:group_value])
          end_date = start_date.next_month.prev_day
          range = "#{start_date.strftime('%d.%m.%Y')} - #{end_date.strftime('%d.%m.%Y')}"

          statistic[:group_value] = range
        end
      end
    end
  end
end
