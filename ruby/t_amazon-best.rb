# -*- coding: utf-8 -*-
require 'anemone'
require 'nokogiri'
require 'kconv'

cookies = {}

opts = {
  :user_agent => '',
  :delay => 1, # 秒数
  :accept_cookies => false,
  :cookies => cookies,
  :depth_limit => 0,
  :proxy_host => nil,
  :proxy_port => nil
}

#クロールの起点となるURLを指定
urls = []
#urls.push("http://www.amazon.co.jp/gp/bestsellers/books/2501045051/") # 本 - コミック・ラノベ・BL
#urls.push("http://www.amazon.co.jp/gp/bestsellers/digital-text/2450063051/") # Kindle - ラノベ・BL
urls.push("http://www.amazon.co.jp/gp/bestsellers/books/2189052051/") # 本 - ライトノベル の ベストセラー
urls.push("http://www.amazon.co.jp/gp/bestsellers/digital-text/2410280051/") # Kindle - ライトノベル の ベストセラー

Anemone.crawl(urls, opts) do |anemone|
  anemone.on_every_page do |page|
    # 文字コードをUTF8に変換したうえで、Nokogiriでパース
    doc = Nokogiri::HTML.parse(page.body.toutf8)

    category = doc.xpath("//*[@id='zg_browseRoot']/ul/li/a").text

    # カテゴリ名の表示
    sub_category = doc.xpath("//*[@id=\"zg_listTitle\"]/span").text

    # サブカテゴリ名をプリント
    puts category+"/"+sub_category
  end
end

Anemone.crawl(urls, :depth_limit => 0) do |anemone|
  anemone.on_every_page do |page|
  # URLをプリント
  puts page.url

  #文字コードをUTF8に変換したうえで、Nokogiriでパース
  doc = Nokogiri::HTML.parse(page.body.toutf8)

  category = doc.xpath("//*[@id='zg_browseRoot']/ul/li/a").text

  #カテゴリ名の表示
  sub_category = doc.xpath("//*[@id=\"zg_listTitle\"]/span").text
  puts category+"/"+sub_category

  items = doc.xpath("//div[@class=\"zg_itemRow\"]/div[1]/div[2]")
  items += doc.xpath("//div[@class=\"zg_itemRow\"]/div[2]/div[2]")
  items.each{|item|

    # 順位
    puts item.xpath("div[1]/span[1]").text

    # 書名
    puts item.xpath("div[\"zg_title\"]/a").text

    # ASIN
    puts item.xpath("div[\"zg_title\"]/a")
      .attribute("href").text.match(%r{dp/(.+?)/})[1]
    }
  end
end