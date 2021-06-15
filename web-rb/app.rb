require 'sinatra'
require 'slim'
require 'securerandom'
require 'logger'

$logger = Logger.new(STDOUT)
$logger.level = Logger::DEBUG

configure {
  set :server, :puma
  set :show_exceptions, true
  set :environment, :development
  set :logging, :true
}

def system_log(cmd)
  $logger.debug("Invoking: #{cmd}\n")
  result = `#{cmd} 2>&1`
  status = $?.exitstatus
  result2 = result.force_encoding('utf-8')
  $logger.debug(result2)
  if status!=0
    raise("Failed to run command: "+result2)
  end
end

class BHXIV < Sinatra::Base
  set :public_folder, 'public'

  helpers do
    def create_workdir(id)
      workdir = "/tmp/#{id}"
      FileUtils.mkdir(workdir)
      workdir
    end

    def stage_zipfile(id, zipfile)
      workdir = create_workdir(id)
      filepath = zipfile[:tempfile].path
      system_log("unzip #{filepath} -d #{workdir}")
    end

    def stage_gitrepo(id, git_url)
      workdir = create_workdir(id)
      system_log("git clone -c core.askPass=echo #{git_url} #{workdir}/#{File.basename(git_url)}")
    end

    def create_outdir(id)
      outdir_path = File.dirname(__FILE__) + "/public/papers/#{id}"
      FileUtils.mkdir_p(outdir_path)
      outdir_path
    end

    def gen_pdf(id, journal)
      # Find paper.md
      glob = "/tmp/#{id}/**/paper.md"
      $logger.debug(glob)
      files = Dir.glob(glob)
      if files.size < 1
        raise "Can not find a paper.md in directory structure!"
      end
      paper_dir = File.dirname(files.first)
      # Prepare output dir
      outdir = create_outdir(id)
      pdf_path = "#{outdir}/paper.pdf"
      # Generate
      system_log("ruby ../bin/gen-pdf #{paper_dir} #{journal} #{pdf_path}")
      # Return pdf_path      "/papers/#{id}/paper.pdf"
      "/papers/#{id}/paper.pdf"
    end
  end

  get '/' do
    # $logger.info('some info')
    # $logger.error('some error')
    # $stderr.print("HELLO\n")
    slim :index
  end

  post '/gen-pdf' do
    # Get form parameters
    $logger.debug(params)
    journal = params[:journal]
    git_url = params[:repository]
    zipfile = params[:zipfile]

    pdf_path = if journal
                 id = SecureRandom.uuid
                 if zipfile
                   stage_zipfile(id, zipfile)
                   gen_pdf(id, journal)
                 elsif git_url
                   stage_gitrepo(id, git_url)
                   gen_pdf(id, journal)
                 end
               end

    if pdf_path
      redirect pdf_path
    else
      status 500
    end
  end

  get '/list' do
    "Hello #{params[:name]}!"
  end
end
