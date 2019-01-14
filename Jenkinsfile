import groovy.transform.Field

@Field def job_name=""
@Field def jenkinsFile=""
def prod_branch = 'master'
if (env.BRANCH_NAME ==  "${prod_branch}") {
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
	    git url:"https://github.com/shansongxian/pipeline.git"
            def check_groovy_file="Jenkinsfile"
            sh "echo $PWD"
	    echo "${check_groovy_file}"
            jenkinsFile=load "${check_groovy_file}"

        }
        jenkinsFile.start()
    }
}
}
