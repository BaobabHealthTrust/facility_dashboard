require 'rubygems'
require 'rest-client'
require 'json'
require 'csv'

Settings = YAML.load_file("#{Rails.root}/cron_jobs/clients.yml")["dde"] rescue {}

def start

  sites = get_sites

  unless sites.blank?
    CSV.open("#{Rails.root}/public/data/sync_data.csv","wb") do |csv|
      csv << ["Site", "Sync Type", "Date"]
      (sites || []).each do |site|
        sync_data = get_syncs(site)
        site_name = sync_data[0]

        case sync_data[1]
          when true:
            sync_type = "Complete"
          when false:
            sync_type = "Partial"
          else sync_type = "Never"
        end
        sync_time = sync_data[2].blank? ? "Never Synced" : sync_data[2]
        csv << [site_name, sync_type,sync_time]
      end
    end
  end



end

def get_sites

  site_codes_output = RestClient.post("http://#{Settings['username']}:#{Settings['password']}@#{Settings['target_server']}:#{Settings['port']}/sites/site_codes",nil)
  site_codes = JSON.parse(site_codes_output)
  return site_codes
end

def get_syncs(site)
  sync_output = RestClient.get("http://admin:admin@192.168.15.5:#{MasterPort}/sites/last_sync?site_code=#{site}")
  output = JSON.parse(sync_output)
  return output
end

start