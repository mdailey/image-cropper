module TokenInputHelper
  def fill_token_input(locator, options)
    raise "Must pass a hash containing 'with'" unless options.is_a?(Hash) && options.has_key?(:with)
    raise "Cannot find token input input field" unless page.find("#token-input-#{locator}")
    page.execute_script %Q{$("#token-input-#{locator}").val('#{options[:with]}').keydown()}
    find(:xpath, "//div[@class='token-input-dropdown']/ul/li[contains(string(),'#{options[:with]}')]", visible: false).click
  end

  def delete_token_input(locator, options)
    raise "Must pass a hash containing 'with'" unless options.is_a?(Hash) && options.has_key?(:with)
    raise "Cannot find token input input field" unless page.find("#token-input-#{locator}")
    within('ul li.token-input-token', text: options[:with]) do
      find('span.token-input-delete-token').click
    end
  end

  protected

  def _find_fillable_field(locator)
    find(:xpath, XPath::HTML.fillable_field(locator), :message => "cannot fill in, no text field, text area or password field with id, name, or label '#{locator}' found")
  end
end

World(TokenInputHelper)
