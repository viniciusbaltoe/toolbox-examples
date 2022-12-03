'''
Deve mostrar:
Nome do Emprego (First and Second Page)
Empresa (First Page)
Local (Second Page)
Postado a quanto tempo (Second Page)
Descrição (Second Page)

'''

import requests
from bs4 import BeautifulSoup

URL = 'https://remote.co/remote-jobs/developer/'
page = requests.get(URL)
# print(page.text) # Print Page HTML text

soup = BeautifulSoup(page.content, "html.parser")
results = soup.find(class_="card bg-white m-0")

# Generic Scraping
job_elements = results.find_all("a", class_="card m-0 border-left-0 border-right-0 border-top-0 border-bottom")
for job_element in job_elements:

    job_name = job_element.find_all("span")[0]
    print(job_name.text.strip())

    job_enterprise = job_element.find("p", class_="m-0 text-secondary")
    for span in job_enterprise.find_all("span", class_="badge badge-success"):
        span.decompose()
    print(job_enterprise.text.replace("|","").strip())

    job_link = job_element["href"]
    URL_2 = "https://remote.co" + job_link
    page_2 = requests.get(URL_2)
    soup_2 = BeautifulSoup(page_2.content, "html.parser")
    results_2 = soup_2.find("div", class_="single_job_listing")

    job_location = results_2.find("div", class_="location_sm")
    print(job_location.text.strip())

    job_date = results_2.find("span", class_="date_sm")
    print(job_date.text.strip())


    flag_list = []
    for flag in results_2.find_all("a", class_="job_flag"):
        flag_list.append(flag.text.strip())
    print(f"Falgs: {flag_list}")

    print(f'Link to Apply: {URL_2}\n')



# Filtred Scraping
'''
engineer_jobs = results.find_all(
    "span", string=lambda text: "engineer" in text.lower()
)
engineer_job_elements = [span_element.parent.parent.parent.parent.parent.parent for span_element in engineer_jobs]
for job_element in engineer_job_elements:
    job_name = job_element.find_all("span")[0]
    print(job_name.text.strip())

    job_enterprise = job_element.find("p", class_="m-0 text-secondary")
    for span in job_enterprise.find_all("span", class_="badge badge-success"):
        span.decompose()
    print(job_enterprise.text.replace("|","").strip())

    job_link = job_element["href"]
    URL_2 = "https://remote.co" + job_link
    page_2 = requests.get(URL_2)
    soup_2 = BeautifulSoup(page_2.content, "html.parser")
    results_2 = soup_2.find("div", class_="single_job_listing")

    job_location = results_2.find("div", class_="location_sm")
    print(job_location.text.strip())

    job_date = results_2.find("span", class_="date_sm")
    print(job_date.text.strip())


    flag_list = []
    for flag in results_2.find_all("a", class_="job_flag"):
        flag_list.append(flag.text.strip())
    print(f"Falgs: {flag_list}")

    print(f'Link to Apply: {URL_2}\n')
'''