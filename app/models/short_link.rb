class ShortLink < ApplicationRecord
	HASH_SALT = "A random salt."

	def self.create_from_url(original_url)
		short_url = Digest::MD5.hexdigest(original_url + HASH_SALT)[0..7]

		ShortLink
			.where(short_url: short_url)
			.first_or_create(short_url: short_url, original_url: original_url)
	end 
end
