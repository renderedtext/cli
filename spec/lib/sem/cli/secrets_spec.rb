require "spec_helper"

describe Sem::CLI::Secrets do

  describe "#list" do
    let(:org1) { ApiResponse.organization(:username => "rt") }
    let(:org2) { ApiResponse.organization(:username => "z-fighters") }

    context "you have at least one secret on semaphore" do
      let(:secret1) { ApiResponse.secret }
      let(:secret2) { ApiResponse.secret }

      before do
        stub_api(:get, "/orgs").to_return(200, [org1, org2])

        stub_api(:get, "/orgs/rt/secrets").to_return(200, [secret1])
        stub_api(:get, "/orgs/z-fighters/secrets").to_return(200, [secret2])

        stub_api(:get, "/secrets/#{secret1[:id]}/config_files").to_return(200, [])
        stub_api(:get, "/secrets/#{secret1[:id]}/env_vars").to_return(200, [])
        stub_api(:get, "/secrets/#{secret2[:id]}/config_files").to_return(200, [])
        stub_api(:get, "/secrets/#{secret2[:id]}/env_vars").to_return(200, [])
      end

      it "lists all secrets" do
        stdout, _stderr = sem_run!("secrets:list")

        expect(stdout).to include(secret1[:id])
        expect(stdout).to include(secret2[:id])
      end
    end

    context "no secret on semaphore" do
      before do
        stub_api(:get, "/orgs").to_return(200, [org1, org2])

        stub_api(:get, "/orgs/rt/secrets").to_return(200, [])
        stub_api(:get, "/orgs/z-fighters/secrets").to_return(200, [])
      end

      it "offers you to set up a secret on semaphore" do
        stdout, _stderr = sem_run!("secrets:list")

        expect(stdout).to include("Create your first secrets")
      end
    end
  end

  describe "#info" do
    context "secrets exists" do
      let(:secret) { ApiResponse.secret(:name => "tokens") }

      before do
        stub_api(:get, "/orgs/rt/secrets").to_return(200, [secret])

        stub_api(:get, "/secrets/#{secret[:id]}/config_files").to_return(200, [])
        stub_api(:get, "/secrets/#{secret[:id]}/env_vars").to_return(200, [])
      end

      it "shows detailed information about a secret" do
        stdout, _stderr = sem_run!("secrets:info rt/tokens")

        expect(stdout).to include(secret[:id])
      end
    end

    context "secrets doesn't exists" do
      before do
        stub_api(:get, "/orgs/rt/secrets").to_return(200, [])
      end

      it "displays an error" do
        _stdout, stderr, status = sem_run("secrets:info rt/tokens")

        expect(stderr).to include("Secret rt/tokens not found.")
        expect(status).to eq(:fail)
      end
    end
  end

  describe "#create" do
    context "creation succeds" do
      let(:secret) { ApiResponse.secret(:name => "tokens") }

      before do
        stub_api(:post, "/orgs/rt/secrets").to_return(200, secret)

        stub_api(:get, "/secrets/#{secret[:id]}/config_files").to_return(200, [])
        stub_api(:get, "/secrets/#{secret[:id]}/env_vars").to_return(200, [])
      end

      it "shows detailed information about a secret" do
        stdout, _stderr = sem_run!("secrets:create rt/tokens")

        expect(stdout).to include(secret[:id])
      end
    end

    context "creation fails" do
      before do
        error = { "message" => "Validation Failed. Name not unique." }
        stub_api(:post, "/orgs/rt/secrets").to_return(422, error)
      end

      it "displays an error" do
        _stdout, stderr, status = sem_run("secrets:create rt/tokens")

        expect(stderr).to include("Validation Failed. Name not unique.")
        expect(status).to eq(:fail)
      end
    end
  end

  describe "#rename" do
    let(:secret) { ApiResponse.secret(:name => "tokens") }

    before do
      stub_api(:get, "/orgs/rt/secrets").to_return(200, [secret])
    end

    context "update succeds" do
      before do
        stub_api(:patch, "/secrets/#{secret[:id]}", :name => "secrets").to_return(200, secret)

        stub_api(:get, "/secrets/#{secret[:id]}/config_files").to_return(200, [])
        stub_api(:get, "/secrets/#{secret[:id]}/env_vars").to_return(200, [])
      end

      it "shows detailed information about secrets" do
        stdout, _stderr = sem_run!("secrets:rename rt/tokens rt/secrets")

        expect(stdout).to include(secret[:id])
      end
    end

    context "update fails" do
      before do
        error = { "message" => "Validation Failed. Name contains spaces" }
        stub_api(:patch, "/secrets/#{secret[:id]}").to_return(422, error)
      end

      it "displays an error" do
        _stdout, stderr, status = sem_run("secrets:rename rt/tokens rt/secrets")

        expect(stderr).to include("Validation Failed. Name contains spaces")
        expect(status).to eq(:fail)
      end
    end
  end

  describe "#delete" do
    let(:secret) { ApiResponse.secret(:name => "tokens") }

    context "deletition succeds" do
      before do
        stub_api(:get, "/orgs/rt/secrets").to_return(200, [secret])
        stub_api(:delete, "/secrets/#{secret[:id]}").to_return(204, "")
      end

      it "shows detailed information about a secret" do
        stdout, _stderr = sem_run!("secrets:delete rt/tokens")

        expect(stdout).to include("Deleted shared configuration rt/tokens")
      end
    end

    context "deletition fails" do
      before do
        stub_api(:get, "/orgs/rt/secrets").to_return(200, [secret])

        error = { "message" => "Shared Config is attached to some projects" }

        stub_api(:delete, "/secrets/#{secret[:id]}").to_return(409, error)
      end

      it "shows detailed information about a secret" do
        _stdout, stderr, status = sem_run("secrets:delete rt/tokens")

        expect(stderr).to include("Shared Config is attached to some projects")
        expect(status).to eq(:fail)
      end
    end
  end

  describe Sem::CLI::Secrets::Files do
    let(:secret) { ApiResponse.secret(:name => "tokens") }

    before do
      stub_api(:get, "/orgs/rt/secrets").to_return(200, [secret])
    end

    describe "#list" do
      context "you have at least one file added to the shared configuration" do
        let(:file1) { ApiResponse.file(:path => "/etc/a") }
        let(:file2) { ApiResponse.file(:path => "/tmp/b") }

        before do
          stub_api(:get, "/secrets/#{secret[:id]}/config_files").to_return(200, [file1, file2])
        end

        it "lists all shared configurations on the project" do
          stdout, _stderr = sem_run("secrets:files:list rt/tokens")

          expect(stdout).to include(file1[:path])
          expect(stdout).to include(file2[:path])
        end
      end

      context "no files are added to the shared configuration" do
        before do
          stub_api(:get, "/secrets/#{secret[:id]}/config_files").to_return(200, [])
        end

        it "offers you to create and attach a shared configuration" do
          stdout, _stderr = sem_run!("secrets:files:list rt/tokens")

          expect(stdout).to include("Add your first file")
        end
      end
    end

    describe "#add" do
      let(:file) { ApiResponse.file(:path => "/etc/a") }

      before do
        body = { :path => "aliases", :content => "abc", :encrypted => true }

        stub_api(:post, "/secrets/#{secret[:id]}/config_files", body).to_return(200, file)
      end

      context "local file exists" do
        before { File.write("/tmp/aliases", "abc") }

        it "adds the file to the shared config" do
          stdout, _stderr = sem_run("secrets:files:add rt/tokens --path-on-semaphore aliases --local-path /tmp/aliases")

          expect(stdout).to include("Added /home/runner/aliases to rt/tokens.")
        end
      end

      context "local file does not exists" do
        before { FileUtils.rm_f("/tmp/aliases") }

        it "aborts and displays an error" do
          _stdout, stderr, status = sem_run("secrets:files:add rt/tokens --path-on-semaphore /etc/aliases --local-path /tmp/aliases")

          expect(status).to be(:fail)
          expect(stderr.strip).to eq("File /tmp/aliases not found")
        end
      end

      context "validation fails" do
        before do
          File.write("/tmp/aliases", "abc")

          error = { "message" => "Path can't be empty" }
          stub_api(:post, "/secrets/#{secret[:id]}/config_files").to_return(422, error)
        end

        it "displays the error" do
          _stdout, stderr, status = sem_run("secrets:files:add rt/tokens --path-on-semaphore /etc/aliases --local-path /tmp/aliases")

          expect(status).to be(:fail)
          expect(stderr).to include("Path can't be empty")
        end
      end
    end

    describe "#remove" do
      let(:file) { ApiResponse.file(:path => "a") }

      before do
        stub_api(:get, "/secrets/#{secret[:id]}/config_files").to_return(200, [file])
        stub_api(:delete, "/config_files/#{file[:id]}").to_return(204, "")
      end

      it "removes the shared configuration to the project" do
        stdout, _stderr = sem_run!("secrets:files:remove rt/tokens --path a")

        expect(stdout).to include("Removed /home/runner/a from rt/tokens")
      end
    end
  end

  describe Sem::CLI::Secrets::EnvVars do
    let(:secret) { ApiResponse.secret(:name => "tokens") }

    before do
      stub_api(:get, "/orgs/rt/secrets").to_return(200, [secret])
    end

    describe "#list" do
      context "you have at least one env_var added to the shared configuration" do
        let(:env_var1) { ApiResponse.env_var }
        let(:env_var2) { ApiResponse.env_var }

        before do
          stub_api(:get, "/secrets/#{secret[:id]}/env_vars").to_return(200, [env_var1, env_var2])
        end

        it "lists all env vars in a secret" do
          stdout, _stderr = sem_run("secrets:env-vars:list rt/tokens")

          expect(stdout).to include(env_var1[:name])
          expect(stdout).to include(env_var2[:name])
        end
      end

      context "no files are added to the shared configuration" do
        before do
          stub_api(:get, "/secrets/#{secret[:id]}/env_vars").to_return(200, [])
        end

        it "offers you to create and attach an env var" do
          stdout, _stderr = sem_run!("secrets:env-vars:list rt/tokens")

          expect(stdout).to include("Add your first environment variable")
        end
      end
    end

    describe "#add" do
      context "adding a new file succeds" do
        let(:env_var) { ApiResponse.env_var }

        before do
          body = { :name => "SECRET", :content => "abc", :encrypted => true }

          stub_api(:post, "/secrets/#{secret[:id]}/env_vars", body).to_return(200, env_var)
        end

        it "adds the env var to the shared config" do
          stdout, _stderr = sem_run!("secrets:env-vars:add rt/tokens --name SECRET --content abc")

          expect(stdout).to include("Added SECRET to rt/tokens")
        end
      end

      context "validation fails" do
        before do
          error = { "message" => "Content can't be empty" }
          stub_api(:post, "/secrets/#{secret[:id]}/config_files").to_return(422, error)
        end

        it "displays the error" do
          _stdout, stderr, status = sem_run("secrets:files:add rt/tokens --path-on-semaphore /etc/aliases --local-path /tmp/aliases")

          expect(status).to be(:fail)
          expect(stderr).to include("Content can't be empty")
        end
      end
    end

    describe "#remove" do
      let(:env_var) { ApiResponse.env_var(:name => "TOKEN") }

      before do
        stub_api(:get, "/secrets/#{secret[:id]}/env_vars").to_return(200, [env_var])
        stub_api(:delete, "/env_vars/#{env_var[:id]}").to_return(204, "")
      end

      it "removes the env vars from the shared configurations" do
        stdout, _stderr = sem_run!("secrets:env-vars:remove rt/tokens --name TOKEN")

        expect(stdout).to include("Removed TOKEN from rt/tokens")
      end
    end

  end
end
