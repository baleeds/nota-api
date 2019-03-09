defmodule PetsWeb.Schema.Pets do
  use Absinthe.Schema.Notation

  alias PetsWeb.Resolvers.Pets.{
    Pet,
    Owner
  }

  alias Pets.Pets

  # # alias Absinthe.Middleware.Dataloader
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :pets_queries do
    field :pets, list_of(non_null(:pet)) do
      resolve(&Pet.all/3)
    end

    field :owners, list_of(non_null(:owner)) do
      resolve(&Owner.all/3)
    end
  end

  object :pets_mutations do
    field :create_pet, :create_pet_payload do
      arg(:input, non_null(:create_pet_input))

      resolve(&Pet.create/3)
    end

    field :add_owner_to_pet, :add_owner_to_pet_payload do
      arg(:input, non_null(:add_owner_to_pet_input))

      resolve(&Pet.add_owner_to_pet/3)
    end

    field :update_pet, :update_pet_payload do
      arg(:input, non_null(:update_pet_input))

      resolve(&Pet.update_pet/3)
    end

    # field :delete_subject, :delete_subject_payload do
    #   arg(:input, non_null(:delete_subject_input))

    #   resolve(&Subject.delete/3)
    # end

    # field :update_subject, :update_subject_payload do
    #   arg(:input, non_null(:update_subject_input))

    #   resolve(&Subject.update/3)
    # end
  end

  object :pet do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:breed, non_null(:string))
    field(:owners, list_of(:owner), resolve: dataloader(Pets.Owner))
  end

  object :owner do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:pets, list_of(:pet), resolve: dataloader(Pets.Pet))
  end

  input_object :create_pet_input do
    field(:name, non_null(:string))
    field(:breed, non_null(:string))
    field(:owner_ids, list_of(non_null(:id))) # article files are like this
  end

  object :create_pet_payload do
    field(:created_pet_id, non_null(:id))
  end

  input_object :add_owner_to_pet_input do
    field(:pet_id, non_null(:id))
    field(:owner_id, non_null(:id))
  end

  object :add_owner_to_pet_payload do
    field(:pet, non_null(:pet))
  end

  input_object :update_pet_input do
    field(:id, :id)
    field(:name, non_null(:string))
    field(:breed, non_null(:string))
    field(:owner_ids, list_of(non_null(:id)))
  end

  object :update_pet_payload do
    field(:pet, non_null(:pet))
  end

  # input_object :delete_subject_input do
  #   field(:id, non_null(:id))
  # end

  # object :delete_subject_payload do
  #   field(:deleted_subject_id, non_null(:id))
  # end

  # input_object :update_subject_input do
  #   field(:id, non_null(:id))
  #   field(:name, non_null(:string))
  #   field(:teacher_id, :id)
  # end

  # object :update_subject_payload do
  #   field(:updated_subject_id, non_null(:id))
  # end
end
