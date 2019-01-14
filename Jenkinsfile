import groovy.transform.Field

@Field def job_name=""
@Field def jenkinsFile=""

node()
{
    // if job is building ...wait
    echo env.JOB_NAME
    job_name="${env.JOB_NAME}".replace('%2F', '/').replace('-', '/').replace('_', '/').split('/')
    echo "${job_name}
    job_name=job_name[0].toLowerCase()
    echo "${job_name}
    workspace="workspace/${job_name}/${env.BRANCH_NAME}"
    ws("$workspace")
    {
        dir("pipeline")
        {   
            def check_groovy_file="Jenkinsfile"
            jenkinsFile=load "${check_groovy_file}"

        }
        jenkinsFile.start()
    }
}
