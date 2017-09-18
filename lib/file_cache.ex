defmodule FileCache do
  @moduledoc """
  Basic file cache wrapper. Useful to store data in files persistently.
  """

  @cache_dir "./cache/"

  def wrap(cache_id, get_data_fn) do
    full_path = @cache_dir <> cache_id
    case File.stat(full_path) do
      {:ok, _} ->
        File.read!(full_path)
      _ ->
        data = get_data_fn.()
        File.write!(full_path, data)
        data
    end
  end
end
