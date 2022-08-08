# frozen_string_literal: true

server ENV.fetch('production_server_ip', nil), user: 'ubuntu', roles: %w[app db web]
