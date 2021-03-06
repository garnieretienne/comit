class Post
  attr_accessor :date, :title, :source, :authors, :history
  attr_accessor :errors

  def initialize(attributes)
    @errors = Hash.new
    @authors = []
    attributes.each do |key, value|
      send("#{key}=", value) if respond_to? "#{key}="
    end
  end

  def valid?
    errors = false

    # title
    case @title
    when nil
      @errors[:title] = "can't be nil"
      errors = true
    end
    
    # date
    case @date
    when nil
      @errors[:date] = "can't be nil"
      errors = true
    end
    
    # source
    case @source
    when nil
      @errors[:source] = "can't be nil"
      errors = true
    end

    # authors
    case
    when @authors.empty?
      @errors[:authors] = "can't be empty"
      errors = true
    end
    
    if errors
      return false
    else
      return true
    end
  end

  def html
    if !self.valid?
      return false
    end

    extentions = {
      autolink: true,
      fenced_code_blocks: true,
      space_after_headers: true,
      tables: true
    }

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extentions)
    return markdown.render(@source)
  end

end