defmodule SmartCity.Dataset.Technical do
  @moduledoc """
  A struct defining technical metadata on a dataset.
  """
  alias SmartCity.Helpers

  @type not_required(type) :: type | nil

  @type t() :: %SmartCity.Dataset.Technical{
          allow_duplicates: not_required(boolean()), # deprecated
          authHeaders: not_required(map()), # deprecated
          authBody: not_required(map()), # deprecated
          authUrl: String.t(), # deprecated
          authBodyEncodeMethod: not_required(String.t()), # deprecated
          cadence: not_required(String.t()), # deprecated
          credentials: boolean(), # deprecated
          dataName: String.t(),
          extractSteps: not_required(list(map())), # deprecated
          orgId: not_required(String.t()),
          orgName: String.t(),
          private: not_required(boolean()),
          protocol: not_required(list(String.t())), # deprecated
          schema: not_required(list(map())),
          sourceHeaders: not_required(map()), # deprecated
          sourceFormat: String.t(), # deprecated
          sourceQueryParams: not_required(map()), # deprecated
          sourceUrl: String.t(), # deprecated
          sourceType: not_required(String.t()),
          systemName: String.t(),
          topLevelSelector: not_required(String.t())
        }

  @derive Jason.Encoder
  defstruct allow_duplicates: true,
            authHeaders: %{},
            authBody: %{},
            authUrl: nil,
            authBodyEncodeMethod: nil,
            cadence: "never",
            credentials: false,
            dataName: nil,
            extractSteps: nil,
            orgId: nil,
            orgName: nil,
            private: true,
            protocol: nil,
            schema: [],
            sourceFormat: nil,
            sourceHeaders: %{},
            sourceQueryParams: %{},
            sourceType: "remote",
            sourceUrl: nil,
            systemName: nil,
            topLevelSelector: nil

  use Accessible

  @doc """
  Returns a new `SmartCity.Dataset.Technical`.
  Can be created from `Map` with string or atom keys.
  Raises an `ArgumentError` when passed invalid input

  ## Parameters

    - msg: Map with string or atom keys that defines the dataset's technical metadata

    _Required Keys_
      - dataName
      - orgName
      - systemName
      - sourceUrl

    - sourceType will default to "remote"
  """
  @spec new(map()) :: SmartCity.Dataset.Technical.t()
  def new(%{"dataName" => _} = msg) do
    msg
    |> Helpers.to_atom_keys()
    |> new()
  end

  def new(%{dataName: _, orgName: _, systemName: _, sourceUrl: _, sourceFormat: type, schema: schema} = msg) do
    msg
    |> Map.put(:schema, Helpers.to_atom_keys(schema))
    |> Map.replace!(:sourceFormat, Helpers.mime_type(type))
    |> create()
  end

  def new(%{dataName: _, orgName: _, systemName: _, sourceUrl: _, sourceFormat: type} = msg) do
    mime_type = Helpers.mime_type(type)

    create(Map.replace!(msg, :sourceFormat, mime_type))
  end

  def new(msg) do
    raise ArgumentError, "Invalid technical metadata: #{inspect(msg)}"
  end

  defp create(%__MODULE__{} = struct) do
    struct |> Map.from_struct() |> create()
  end

  defp create(map), do: struct(%__MODULE__{}, map)
end
