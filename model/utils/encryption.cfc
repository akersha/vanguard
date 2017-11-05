<cfcomponent displayname="ApplicationService" hint="Encrytpion methods" output="false" accessors="true">

		<!--- Encryption key used by the Dashboard. --->
		<cfproperty name="enckey" type="string" defaulkt = "fGAsZzxg+au/emzxMcoy0g==">

        <cffunction name="init" access="public" output="false" returntype="ApplicationService">
                <cfreturn this />
        </cffunction>

		<cffunction name="encryptString"
			returntype="string"
			access="public"
			output="false"
			hint="Returns an encrypted string">
			<cfargument name="PlainText" type="string" required="true" hint="The string to be encrypted.">

			<cfreturn Encrypt(plaintext,getEnckey()),"aes","hex")>
		</cffunction>

		<cffunction name="decryptString"
			returntype="string"
			access="public"
			output="false"
			hint="Returns an decrypted string that was encrypted using the encryptString method.">
			<cfargument name="EncryptedString" type="string" required="true" hint="The string to be decrypted.">

			<cfreturn Decrypt(encryptedstring,getEnckey(),"aes","hex")>
		</cffunction>

</cfcomponent>