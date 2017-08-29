module PkgAdapter

  class Apk < BaseAdapter
    require 'ruby_apk'

    def parse
      @apk = Android::Apk.new(@path)
      if file_name = @apk.icon.keys.last
        icon = @apk.icon[file_name]
        path = tmp_dir
        FileUtils.rm_rf path
        @app_icon = "#{path}/#{File.basename(file_name)}"
        dirname = File.dirname(@app_icon)
        FileUtils.mkdir_p dirname
        File.open("#{@app_icon}", 'wb') { |file| file.write(icon) } if icon
      end
    end

    def plat
      'android'
    end

    def app_uniq_key
      :build
    end

    def app_name
      @apk.manifest.label
    end

    def app_version
      @apk.manifest.version_name
    end

    def app_build
      "#{@apk.manifest.version_code}"
    end

    def app_icon
      @app_icon
    end

    def app_size
      File.size(@path)
    end

    def app_ident
      @apk.manifest.package_name
    end

  end
end