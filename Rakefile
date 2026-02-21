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
URL = 'https://jpn.bible'
BASE_URL = URL + '/kougo/'

def erb_raw(source_file, vars = {})
  ERB.new(File.read(source_file), trim_mode: '-').result_with_hash(vars)
end

def erb(source_file, dest_file, vars = {})
  File.write(dest_file, erb_raw(source_file, vars))
end

HEAD = erb_raw('template/head.html.erb', gtag_tracking_id: GTAG_TRACKING_ID, url: URL, css: 'global')
NAV = erb_raw('template/nav.html.erb')
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
    if t.name.end_with?('index.html')
      erb(t.source, t.name, var_table(t.name, additional_title, prefetches: true))
      sh "sed -i 's/\\.html//g' #{t.name}"
    else # each book
      additional_title.prepend(" (#{VERSION_NAME[:kougo]})")
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
  head = erb_raw('template/head.html.erb', gtag_tracking_id: GTAG_TRACKING_ID, url: URL, css: 'index')
  erb(t.source, t.name, title: TOP_TITLE, gtag_tracking_id: GTAG_TRACKING_ID, head:)
end
