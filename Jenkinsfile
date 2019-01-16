import groovy.transform.Field

@Field def job_name=""
@Field def jenkinsFile=""
node()
{
properties([parameters([choice(choices: ['search', 'rollback'], description: '''search:搜索helm仓库当前所有版本
rollback:回滚指定版本''', name: ''), string(defaultValue: '', description: 'Tag:输入指定版本', name: 'Tag', trim: true)])])

    job_name="${env.JOB_NAME}".replace('%2F', '/').replace('-', '/').replace('_', '/').split('/')
    job_name=job_name[0].toLowerCase()
    workspace="workspace/${job_name}/${env.BRANCH_NAME}"
    ws("$workspace")
	{
        dir("pipeline")
        {   
	    git url:"https://github.com/shansongxian/pipeline.git"
            def check_groovy_file="${job_name}/Jenkinsfile"
            def default_groovy_file="default/Jenkinsfile"
            jenkinsFile=load "${check_groovy_file}"

        }
    }
}
