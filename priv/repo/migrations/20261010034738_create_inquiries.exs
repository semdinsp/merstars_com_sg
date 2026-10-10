defmodule MerstarsComSg.Repo.Migrations.CreateInquiries do
  use Ecto.Migration

  def change do
    create table(:inquiries) do
      add :kind, :string, null: false
      add :name, :string, null: false
      add :company, :string
      add :email, :string, null: false
      add :phone, :string
      add :subject, :string
      add :origin, :string
      add :destination, :string
      add :message, :text, null: false
      add :emailed_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create index(:inquiries, [:kind, :inserted_at])
  end
end
