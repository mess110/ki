module Ki
  module PublicFileHelper
    def public_file_exists? path
      path = path.path if path.class == BaseRequest
      File.file?(public_file_path(path))
    end

    def public_file_path path
      path = path.path if path.class == BaseRequest
      File.join(Ki::PUBLIC_PATH, path)
    end
  end
end
