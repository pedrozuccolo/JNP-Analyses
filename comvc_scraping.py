from selenium import webdriver

# Path to the ChromeDriver executable
chrome_driver_path = '/Users/pedrozuccolo/chromedriver_mac_arm64'

# Configure Chrome options
chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument("--headless")  # Run Chrome in headless mode (without opening a browser window)

# Create a WebDriver instance
driver = webdriver.Chrome(options=chrome_options)

# Define the login URL and target URL
login_url = 'https://comvc.app/login'
target_url = 'https://comvc.app'

# Perform the login
driver.get(login_url)
username_input = driver.find_element(By.CSS_SELECTOR, 'input[name="pedro_zuccolo"]')
username_input.send_keys('p3dr0')
driver.find_element_by_css_selector('button[type="submit"]').click()

# Wait for the page to load after login
driver.implicitly_wait(10)  # Adjust the wait time as needed

# Navigate to the target page
driver.get(target_url)

# Get the page content after executing JavaScript
page_content = driver.page_source

# Print the page content
print(page_content)

# Close the browser
driver.quit()
