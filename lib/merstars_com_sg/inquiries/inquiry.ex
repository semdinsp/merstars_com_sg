defmodule MerstarsComSg.Inquiries.Inquiry do
  @moduledoc """
  A contact-us message or a request for quote submitted from the website.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @kinds ~w(contact quote)

  schema "inquiries" do
    field :kind, :string
    field :name, :string
    field :company, :string
    field :email, :string
    field :phone, :string
    field :subject, :string
    field :origin, :string
    field :destination, :string
    field :message, :string
    field :emailed_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @fields %{
    "contact" => {~w(name phone email subject message)a, ~w(name email message)a},
    "quote" =>
      {~w(name company email phone origin destination message)a,
       ~w(name email origin destination message)a}
  }

  @doc """
  Casts the fields shown on the form for `kind` ("contact" or "quote") and
  validates them.
  """
  def changeset(%__MODULE__{} = inquiry, kind, attrs) when kind in @kinds do
    {fields, required} = @fields[kind]

    inquiry
    |> cast(attrs, fields)
    |> put_change(:kind, kind)
    |> validate_required(required, message: "Please fill this in")
    |> validate_format(:email, ~r/^[^\s@]+@[^\s@]+\.[^\s@]+$/,
      message: "Please enter a valid email address"
    )
    |> validate_length(:message, max: 5000)
    |> validate_length(:email, max: 160)
    |> then(fn cs ->
      Enum.reduce(fields -- [:message], cs, &validate_length(&2, &1, max: 200))
    end)
  end
end
