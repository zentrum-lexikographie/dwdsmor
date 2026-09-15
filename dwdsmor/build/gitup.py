from os import environ

from gitlab import Gitlab

gitup_url = environ.get("DWDSMOR_GITUP_URL", "https://gitup.uni-potsdam.de")
job_token = environ.get("CI_JOB_TOKEN")
private_token = environ.get("DWDSMOR_GITUP_PAT")

dwdsmor_project_id = int(environ.get("DWDSMOR_GITUP_PROJECT_ID", "21585"))
dwdswb_project_id = int(environ.get("DWDSMOR_GITUP_DWDSWB_PROJECT_ID", "21451"))

api = Gitlab(
    gitup_url,
    private_token=private_token,
    job_token=(job_token if not private_token else None),
)


def dwdswb_project():
    return api.projects.get(dwdswb_project_id, lazy=True)


def dwdswb_date():
    packages = dwdswb_project().packages.list(package_type="generic", get_all=True)
    versions = (
        p.attributes["version"] for p in packages if p.attributes["name"] == "dwdswb"
    )
    version, *_ = sorted(versions, reverse=True)
    return version


def dwdsmor_project():
    return api.projects.get(dwdsmor_project_id, lazy=True)


def dwdsmor_versions():
    packages = dwdsmor_project().packages.list(get_all=True)
    versions = {
        p.attributes["version"]
        for p in packages
        if p.attributes["name"].startswith("dwdsmor-dwds")
    }
    return versions
