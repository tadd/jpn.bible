require 'rake/clean'
require 'erb'
require 'fileutils'

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
HEAD = <<EOS.chomp
<script async="async" src="https://www.googletagmanager.com/gtag/js?id=#{GTAG_TRACKING_ID}"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', '#{GTAG_TRACKING_ID}');
</script>
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous"/>
<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+JP&amp;display=swap" rel="stylesheet"/>
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
TOP_TITLE = 'jpn.bible - 日本語フリー聖書ポータル'

CLEAN.concat(ERBS + [SOURCE])
CLOBBER.concat(TARGETS + %w[public/index.html])

task default: %w[kougo root]

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
  end.join
end

def preload_tags
  ''
end

file SOURCE => SOURCE + '.zip' do |t|
  sh "unzip -p #{t.source} > #{t.name}"
end

TARGETS.zip(ERBS).each do |target, erb|
  file target => [erb, __FILE__] do |t|
    FileUtils.mkdir_p('public/kougo')
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
    FileUtils.mkdir_p('tmp/erb')
    sh "bundle exec osis2html5 --erb #{t.source} tmp/erb/"
  end
end

task root: %w[public/index.html]

file 'public/index.html' => 'template/index.html.erb' do |t|
  erb(t.source, t.name, title: TOP_TITLE, gtag_tracking_id: GTAG_TRACKING_ID)
end
