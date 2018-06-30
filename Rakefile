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
GTAG_TRACKING_ID = ENV.fetch('GTAG_TRACKING_ID')
HEAD = <<EOS.chomp # add bootstrap things
<script async="async" src="https://www.googletagmanager.com/gtag/js?id=#{GTAG_TRACKING_ID}"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', '#{GTAG_TRACKING_ID}');
</script>
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous"/>
<link rel="canonical" href="%<url>s"/>
<meta property="og:url" content="%<url>s"/>
<link rel="stylesheet" href="/css/global.css"/>
<link rel="icon" type="image/svg+xml" href="/img/logo.svg"/>
<link rel="shortcut icon" type="image/x-icon" href="/favicon.ico"/>
EOS
NAV = <<EOS.chomp
<nav class="navbar navbar-expand-sm bg-light navbar-light fixed-top">
<a class="navbar-brand" href="/">
<img src="/img/logo.svg" alt="jpn.bibleロゴ" width="30" height="30"/>
jpn.bible
</a>
</nav>
EOS
BASE_URL = 'https://jpn.bible/kougo/'
VERSION_NAME = {
  kougo: '口語訳聖書 1954/1955版'
}
GLOBAL_ADDTIONAL_TITLE = ' - jpn.bible'

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

def var_table(filename, additional_title, prefetches: false, preloads: false)
  table = {
    head: format(HEAD, url: filename_to_url(filename)),
    additional_title: additional_title,
    head_of_body: NAV
  }
  table[:head] << prefetch_tags if prefetches
  table[:head] << preload_tags if preloads
  table
end

def prefetch_tags
  %w[gen].map do |book|
    %(\n<link rel="next" href="#{book}"/>)
  end.join +
    %(\n<link rel="prefetch" href="/font/NotoSerifJP-Regular.woff2" as="font" type="font/woff2"/>)
end

def preload_tags
  %(\n<link rel="preload" href="/font/NotoSerifJP-Regular.woff2" as="font" type="font/woff2"/>)
end

file SOURCE => SOURCE + '.zip' do |t|
  sh "unzip -p #{t.source} > #{t.name}"
end

TARGETS.zip(ERBS).each do |target, erb|
  file target => [erb, __FILE__] do |t|
    Dir.mkdir('public/kougo') unless Dir.exist?('public/kougo')
    additional_title = GLOBAL_ADDTIONAL_TITLE.dup
    additional_title.prepend(" (#{VERSION_NAME[:kougo]})") unless t.name.end_with?('index.html')
    if t.name.end_with?('index.html')
      erb(t.source, t.name, var_table(t.name, additional_title, prefetches: true))
      sh "sed -i 's/\\.html//g' #{t.name}"
    else # each book
      erb(t.source, t.name, var_table(t.name, additional_title, preloads: true))
    end
  end

  file erb => SOURCE do |t|
    sh 'mkdir -p tmp/erb'
    sh "bundle exec osis2html5 --erb #{t.source} tmp/erb/"
  end
end
