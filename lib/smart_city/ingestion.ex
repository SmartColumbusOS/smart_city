defmodule SmartCity.Ingestion do
    alias SmartCity.Helpers

    @moduledoc """
    Struct defining an ingestion update event.
  
    ```javascript
    const Ingestion = {
      "cadence": "",
      "extractSteps": [],          
      "schema": [],
      "targetDatasetId": "",          
      "sourceFormat": "",
      "sourceType": ""    
    }
    ```
    """
    @type not_required(type) :: type | nil
    
    @type t :: %SmartCity.Ingestion{
        cadence: not_required(String.t()),
        extractSteps: not_required(list(map())),
        schema: not_required(list(map())),
        sourceFormat: String.t(),
        sourceType: not_required(String.t()),
        targetDataset: String.t()
    }
  
    @derive Jason.Encoder
    defstruct cadence: "never",
              extractSteps: [],
              schema: [],
              targetDataset: nil,
              sourceFormat: nil,
              sourceType: "remote"

    use Accessible

    @doc """
    Returns a new `SmartCity.Ingestion`.
    Can be created from `Map` with string or atom keys.
    Raises an `ArgumentError` when passed invalid input

    ## Parameters

    - msg: Map with string or atom keys that defines the ingestion metadata

    Required Keys:
        - targetDataset
        - sourceFormat

    - sourceType will default to "remote"
    - cadence will default to "never"
    """
    @spec new(map()) :: SmartCity.Ingestion.t()
    def new(%{"targetDataset" => _} = msg) do
        msg
        |> Helpers.to_atom_keys()
        |> new()
    end

    def new(%{targetDataset: _, sourceFormat: type, schema: schema } = msg) do
    msg
        |> Map.put(:schema, Helpers.to_atom_keys(schema))
        |> Map.replace!(:sourceFormat, Helpers.mime_type(type))
        |> create()
    end

    def new(%{targetDataset: _, sourceFormat: type} = msg) do
        mime_type = Helpers.mime_type(type)

        create(Map.replace!(msg, :sourceFormat, mime_type))
    end

    def new(msg) do
        raise ArgumentError, "Invalid ingestion metadata: #{inspect(msg)}"
    end

    defp create(%__MODULE__{} = struct) do
        struct |> Map.from_struct() |> create()
    end

    defp create(map), do: struct(%__MODULE__{}, map)
end
