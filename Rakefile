require 'rake/clean'
require 'erb'
require_relative 'app'

TARGETS = FileList[JpnBible::BOOKS + %w[index]].pathmap('bibles/kougo/%f.html')
SOURCE = 'vendor/bibles/kougo.osis'
ERBS = TARGETS.pathmap('tmp/erb/%f.erb')
HEAD = <<EOS.chomp # add bootstrap things
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous"/>
EOS

CLEAN.concat(ERBS)
CLOBBER.concat(TARGETS)

task default: %w[kougo]

desc 'generate Kougo bible HTMLs'
task kougo: TARGETS

VAR_TABLE = {
  head: HEAD
}

def erb(source_file, dest_file, vars = {})
  applied = ERB.new(File.read(source_file)).result_with_hash(vars)
  File.write(dest_file, applied)
end


TARGETS.zip(ERBS).each do |target, erb|
  file target => erb do |t|
    erb(t.source, t.name, VAR_TABLE)
    sh "sed -i 's/\\.html//g' #{t.name}" if t.name.end_with?('index.html')
  end
end

desc 'generate temporary *.html.erb files'
task erb: SOURCE do |t|
  sh 'mkdir -p tmp/erb'
  sh "bundle exec osis2html5 --erb #{t.source} tmp/erb/"
end

ERBS.each do |erb|
  task erb => :erb
end
