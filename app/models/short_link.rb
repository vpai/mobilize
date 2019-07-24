class ShortLink < ApplicationRecord
	HASH_SALT = "A random salt."
	SECONDS_IN_DAY = 86400

	def self.create_from_url(original_url)
		short_url = Digest::MD5.hexdigest(original_url + HASH_SALT)[0..7]

		ShortLink
			.where(short_url: short_url)
			.first_or_create(short_url: short_url, original_url: original_url)
	end 

	def update_stats
		start_of_day = (Time.now.to_i / SECONDS_IN_DAY) * SECONDS_IN_DAY

		$redis.zincrby(self.short_url, 1, start_of_day)
	end 

	def hit_by_day_hash
		hits_by_day.map do |k|
			[Time.at(k[0].to_i).utc.to_datetime.strftime('%F'), k[1]]
		end.to_h
	end 

	def total_hits
		hits_by_day.map { |k| k[1].to_i }.sum
	end

	private

	def hits_by_day
		@hits_by_day ||= $redis.zrange(self.short_url, 0, -1, :with_scores => true)
	end
end
