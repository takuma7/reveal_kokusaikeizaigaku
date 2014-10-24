require 'origami'

if ARGV.empty?
  puts "Usage: ruby revleal_kokusaikeizaigaku.rb <file>..."
  exit 1
end

ARGV.each do |filename|
  puts "="*80
  puts filename
  puts "="*80
  pdf = Origami::PDF.read(filename)
  r = /q\r\nBT\r\n?[\s\S]+?ET\r\nQ\r\n/m
  pdf.pages.each.with_index do |page, i|
    data = page.Contents.data
    strs = data.scan(r)
    data.gsub(r, "")
    data += strs.join
    pdf.pages[i].Contents.data = data
    pdf.pages[i].Contents.pre_build
    puts "page: #{i+1}/#{pdf.pages.size}"
  end
  puts "saving..."
  pdf.save(filename)
  puts "done"
end
