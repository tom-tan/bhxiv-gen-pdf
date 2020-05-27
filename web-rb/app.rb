require 'sinatra'
require 'slim'
require 'securerandom'

class BHXIV < Sinatra::Base
  set :public_folder, 'public'

  helpers do
    def gen_pdf(git_url, journal)
      # Create tmpdir for this process
      uuid = SecureRandom.uuid

      tmpdir_path = "/tmp/#{uuid}"
      outdir_path = File.dirname(__FILE__) + "/public/papers/#{uuid}"
      FileUtils.mkdir_p(tmpdir_path)
      FileUtils.mkdir_p(outdir_path)

      # Clone repository
      repo_dest = "#{tmpdir_path}/#{File.basename(git_url)}"
      system("git clone #{git_url} #{repo_dest}")

      # Find paper.md
      paper_dir = File.dirname(Dir.glob("#{repo_dest}/**/paper.md").first)

      # Generate pdf
      pdf_path = "#{tmpdir_path}/paper.pdf"
      system("ruby /gen-pdf/bin/gen-pdf #{paper_dir} #{journal} #{pdf_path}")

      # Copy output pdf to public folder
      FileUtils.cp(pdf_path, outdir_path)

      "/papers/#{uuid}/paper.pdf"
    end
  end

  get '/' do
    slim :index
  end

  post '/gen-pdf' do
    # Get form parameters
    git_url = params[:repository]
    journal = params[:journal]

    if git_url && journal
      pdf_path = gen_pdf(git_url, journal)
      redirect pdf_path
    else
      status 500
    end
  end
end
