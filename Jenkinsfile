import groovy.transform.Field

@Field def job_name=""
@Field def jenkinsFile=""
node()
{
    job_name="${env.JOB_NAME}".replace('%2F', '/').replace('-', '/').replace('_', '/').split('/')
    job_name=job_name[0].toLowerCase()
    workspace="workspace/${job_name}/${env.BRANCH_NAME}"
    ws("$workspace")
	{
        dir("pipeline")
        {   
	    git url:"https://github.com/shansongxian/pipeline.git"
            def check_groovy_file="${job_name}/Jenkinsfile"
            jenkinsFile=load "${check_groovy_file}"

        }
    }
}
