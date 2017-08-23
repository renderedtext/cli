class Sem::SRN
  # Semaphore Resource Name

  class << self
    def parse_org(semaphore_resource_name)
      parse_srn(semaphore_resource_name, "org_name")
    end

    def parse_team(semaphore_resource_name)
      parse_srn(semaphore_resource_name, "org_name/team_name")
    end

    def parse_project(semaphore_resource_name)
      parse_srn(semaphore_resource_name, "org_name/project_name")
    end

    def parse_shared_config(semaphore_resource_name)
      parse_srn(semaphore_resource_name, "org_name/shared_config_name")
    end

    def parse_user(semaphore_resource_name)
      parse_srn(semaphore_resource_name, "user_name")
    end

    private

    def parse_srn(semaphore_resource_name, format)
      srn_tokens    = semaphore_resource_name.to_s.split("/")
      format_tokens = format.split("/")

      resource = format_tokens.last.split("_").tap(&:pop).join("_")

      if srn_tokens.count != format_tokens.count
        message = "Invalid format for #{resource}: \"#{semaphore_resource_name}\".\n" \
          "Required format is: \"#{format}\"."

        raise Sem::Errors::InvalidSRN, message
      end

      srn_tokens
    end
  end
end
