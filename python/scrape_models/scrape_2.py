import requests
from bs4 import BeautifulSoup

URL = 'https://pythonjobs.github.io'
page = requests.get(URL)
# print(page.text) # Print Page HTML text

soup = BeautifulSoup(page.content, "html.parser")
results = soup.find(id="main")

# Generic Scraping
'''
job_elements = results.find_all("div", class_="job")
for job_element in job_elements:
    job_name = job_element.find_all("h1")[0]    # Apenas o primeiro
    spans = job_element.find_all("span", class_='info')
    job_location, job_date, job_status, job_enterprise = spans[0], spans[1], spans[2], spans[3]
    job_description = job_element.find("p", class_='detail') 
    job_link = job_element.find('a', class_='go_button')["href"]

    print(job_name.text.strip())
    print(job_location.text.strip())
    print(job_date.text.strip())
    print(job_status.text.strip())
    print(job_enterprise.text.strip())
    print(job_description.text.strip())
    print(f'Link to Apply: {URL + job_link}\n')
    print()
'''

# Filtred Scraping
python_jobs = results.find_all(
    "h1", string=lambda text: "python" in text.lower()
)
python_job_elements = [
    h1_element.parent.parent.parent for h1_element in python_jobs
]
for job_element in python_job_elements:
    job_name = job_element.find_all("h1")[0]    # Apenas o primeiro
    spans = job_element.find_all("span", class_='info')
    job_location, job_date, job_status, job_enterprise = spans[0], spans[1], spans[2], spans[3]
    job_description = job_element.find("p", class_='detail') 
    job_link = job_element.find('a', class_='go_button')["href"]

    print(job_name.text.strip())
    print(job_location.text.strip())
    print(job_date.text.strip())
    print(job_status.text.strip())
    print(job_enterprise.text.strip())
    print(job_description.text.strip())
    print(f'Link to Apply: {URL + job_link}\n')
    print()

