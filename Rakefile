require 'rake/clean'
require 'erb'

BOOKS =
  # old
  %w[
    gen exod lev num deut josh judg ruth 1sam 2sam 1kgs 2kgs 1chr 2chr ezra neh esth job ps
    prov eccl song isa jer lam ezek dan hos joel amos obad jonah mic nah hab zeph hag zech mal
  ] +
  # new
  %w[
    matt mark luke john acts rom 1cor 2cor gal eph phil col 1thess 2thess 1tim 2tim titus phlm
    heb jas 1pet 2pet 1john 2john 3john jude rev
  ]
TARGETS = FileList[BOOKS + %w[index]].pathmap('public/kougo/%f.html')
SOURCE = 'vendor/kougo.osis'
ERBS = TARGETS.pathmap('tmp/erb/%f.erb')
HEAD = <<EOS.chomp # add bootstrap things
<script async="async" src="https://www.googletagmanager.com/gtag/js?id=UA-1773020-8"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', '#{ENV.fetch("GTAG_TRACKING_ID")}');
</script>
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous"/>
<link rel="canonical" href="%<url>s"/>
<meta property="og:url" content="%<url>s"/>
<link rel="stylesheet" href="/css/global.css"/>
EOS
BASE_URL = 'https://jpn.bible/kougo/'

CLEAN.concat(ERBS + [SOURCE])
CLOBBER.concat(TARGETS)

task default: %w[kougo]

desc 'generate Kougo bible HTMLs'
task kougo: TARGETS

def erb(source_file, dest_file, vars = {})
  applied = ERB.new(File.read(source_file)).result_with_hash(vars)
  File.write(dest_file, applied)
end

def filename_to_url(filename)
  base = File.basename(filename, '.html')
  if base == 'index'
    BASE_URL
  else
    BASE_URL + base
  end
end

def var_table(filename)
  {
    head: format(HEAD, url: filename_to_url(filename))
  }
end

file SOURCE => SOURCE + '.zip' do |t|
  sh "unzip -p #{t.source} > #{t.name}"
end

TARGETS.zip(ERBS).each do |target, erb|
  file target => erb do |t|
    erb(t.source, t.name, var_table(t.name))
    sh "sed -i 's/\\.html//g' #{t.name}" if t.name.end_with?('index.html')
  end

  file erb => SOURCE do |t|
    sh 'mkdir -p tmp/erb'
    sh "bundle exec osis2html5 --erb #{t.source} tmp/erb/"
  end
end
