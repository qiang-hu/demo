import groovy.transform.Field

@Field def job_name=""
@Field def jenkinsFile=""

node()
{
    // if job is building ...wait
    echo env.JOB_NAME
    job_name="${env.JOB_NAME}".replace('%2F', '/').replace('-', '/').replace('_', '/').split('/')
    job_name=job_name[0].toLowerCase()
    workspace="workspace/${job_name}/${env.BRANCH_NAME}"
    ws("$workspace")
    {
        
        dir("pipeline")
        {   
            def check_groovy_file="Jenkinsfile"
            def default_groovy_file="Jenkinsfile/default/Jenkinsfile.groovy"

            jenkinsFile=load "${check_groovy_file}"

        }
        jenkinsFile.start()
    }
}
