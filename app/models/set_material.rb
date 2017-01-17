class SetMaterial
	include SetMaterialClient
	include ActiveModel::Model

	validates :name, presence: true	

	attr_accessor :uuid, :name

	def self.create_remote_set(submission_id)
	  	create SetMaterialClient::post(submission_id)
	end

	def self.get_remote_set(uuid)
		SetMaterialClient::get(uuid)
	end

	def self.add_materials_to_set(uuid, materials)
		SetMaterialClient::add_materials(uuid, materials)
	end

	def self.get_remote_set_with_materials(uuid)
		SetMaterialClient::get_with_materials(uuid)
	end

	private 

	def self.create(obj)
	  	new filter(obj)
	end

	def self.filter(h)
		{:uuid => h["data"]["id"], :name => h["data"]["attributes"]["name"]}
	end

end