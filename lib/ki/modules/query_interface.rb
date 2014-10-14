module Ki
  class Model
    # the query interface does not respect before/after filters,
    # unique attributes, required attributes or anything of the
    # sort.
    # it writes directly to the database
    module QueryInterface
      def count hash={}
        Orm::Db.instance.count class_name, hash
      end

      def find hash={}
        Orm::Db.instance.find class_name, hash
      end

      def create hash
        Orm::Db.instance.insert class_name, hash
      end

      def find_or_create hash
        r = find hash
        r.empty? ? create(hash) : r
      end

      def update hash
        Orm::Db.instance.update class_name, hash
      end

      def delete hash
        Orm::Db.instance.delete class_name, hash
      end

      def class_name
        self.to_s
      end
    end
  end
end
