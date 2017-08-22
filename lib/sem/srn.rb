class Sem::SRN
  # Semaphore Resource Name

  class << self
    def parse_org(semaphore_resource_name)
      parse_srn(semaphore_resource_name, "org")
    end

    def parse_team(semaphore_resource_name)
      parse_srn(semaphore_resource_name, "org/team")
    end

    def parse_project(semaphore_resource_name)
      parse_srn(semaphore_resource_name, "org/project")
    end

    def parse_shared_config(semaphore_resource_name)
      parse_srn(semaphore_resource_name, "org/shared_config")
    end

    private

    def parse_srn(semaphore_resource_name, format)
      srn_tokens    = semaphore_resource_name.to_s.split("/")
      format_tokens = format.split("/")

      if srn_tokens.count != format_tokens.count
        message = "Invalid format for #{format_tokens.last}: \"#{semaphore_resource_name}\".\n" \
          "Required format is: \"#{format}\"."

        raise Sem::Errors::InvalidSRN, message
      end

      srn_tokens
    end
  end
end
