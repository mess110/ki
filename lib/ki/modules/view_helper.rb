module Ki
  module ViewHelper
    def view_exists? path
      path = path.path if path.class == BaseRequest
      File.file?(view_path(path))
    end

    def view_path path
      path = path.path if path.class == BaseRequest
      File.join(Ki::VIEWS_PATH, path + ".haml")
    end
  end
end
