defmodule Bkdrf do
  @moduledoc """
  Simple app to parse bkdrf.ru website and do some calculations with the data
  presented on this site.
  """

  use PhoenixHtmlSanitizer, :basic_html

  @basic_url "http://bkdrf.ru/"

  @doc """
  Gets and show info about given city. Page: http://bkdrf.ru/map/<city>
  Check the page existence before running this code :D

  ## Examples

      iex> Bkdrf.get "saratov"
      ...
  """
  def get(city) do
    @basic_url <> "map/#{city}"
    |> get_html
    |> get_json_data
    |> parse_json
    |> get_detailed_info
    |> convert_detailed_info
    |> show_results
  end

  defp get_html(url) do
    FileCache.wrap(String.replace(url, "/", "_"), fn -> HTTPoison.get!(url).body end)
  end

  defp get_json_data(raw_html) do
    Regex.run(~r/var demoData = "(.+)";/, raw_html)
    |> tl
    |> to_string
    |> String.replace("\\u0022", "\"")
  end

  defp parse_json(data) do
    Poison.decode!(data)
  end

  defp get_detailed_info(points_list) do
    points_list["features"]
    |> Enum.map(fn(el) -> el["properties"]["id"] end)
    |> Enum.uniq
    |> Enum.map(fn(uuid) -> {uuid, get_details(uuid) |> HtmlEntities.decode} end)
    |> Enum.map(fn({uuid, details}) -> {uuid, elem(sanitize(details), 1)} end)
  end

  defp convert_detailed_info(details) do
    # Example of details (line numbers added for simplicity):
    # 0  <h3>Установка пешеходных ограждений</h3>
    # 1  <h4>Информация об объекте</h4>
    # 2  <b>Наименование</b>
    # 3  <p>Автомобильная дорога по ул. Тельмана</p>
    # 4  <b>Статус</b>
    # 5  <p>Запланирован</p>
    # 6  <b>Год работ</b>
    # 7  <p>2017</p>
    # 8  <b>Дата начала</b>
    # 9  <p>01.04.2017</p>
    # 10 <b>Дата окончания</b>
    # 11 <p>31.08.2017</p>
    # 12 <b>Описание</b>
    # 13 <p>Установка в районе МБОУ \"СОШ № 1\" пешеходных ограждений протяженностью 100 метров</p>
    # 14 <a href=\"#more\">Показать еще детали</a>
    # 15 <b>Основание работ</b>
    # 16 <p>Экспертная оценка, рекомендации ГИБДД</p>
    # 17 <b>Выполнено</b>
    # 18 <p>0%<span></span></p>
    # 19 <b>Стоимость работ</b>
    # 20 <p>0.2 млн руб.</p>
    Enum.map(details,
      fn ({uuid, html_info}) ->
        [
          type,
          _,
          _,
          address,
          _,
          status,
          _,
          year,
          _,
          start_date,
          _,
          end_date,
          _,
          description,
          _,
          _,
          substantiation,
          _,
          progress,
          _,
          _,
          price,
          _
        ] = html_info
        |> String.replace(~r/(<\/[a-z0-9]+>)/, "\\1\n")
        |> String.split("\n")
        |> Enum.map(fn(piece) -> elem(sanitize(piece, :strip_tags), 1) end)

        {uuid, [
          type: type,
          address: address,
          status: status,
          year: year,
          start_date: start_date,
          end_date: end_date,
          description: description,
          substantiation: substantiation,
          progress: progress,
          price: price
        ]}
      end
    )
  end

  defp show_results(info) do
    info
    |> Enum.map(fn ({uuid, details}) ->
      IO.puts "---"
      IO.puts uuid
      IO.puts details[:type]
      IO.puts details[:address]
      IO.puts "#{details[:start_date]}\t#{details[:end_date]}\t#{details[:status]}\t#{details[:price]}"
    end)

    total_price = info
    |> Enum.map(fn ({_, details}) -> details[:price] end)
    |> List.foldl(0, fn(x, acc) -> elem(Float.parse(x), 0) + acc end)

    IO.puts "Total price: #{total_price} millions rubles"
  end

  defp get_details(uuid) do
    FileCache.wrap(uuid, fn -> HTTPoison.get!(@basic_url <> "fragmentInfo/" <> uuid).body end)
  end
end
