package nl.assai.fqt.domain.ibatis.dao.fqt;

import nl.assai.fqt.domain.model.fqt.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

public class FqtDao extends SqlMapClientDaoSupport {
    private static final Logger logger = LoggerFactory.getLogger(FqtDao.class);

    @Autowired
    private Properties config;

    public void setJournalingUser(String userName) {
        logger.debug("setJournalingUser for: " + userName);
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            getSqlMapClientTemplate().update("setJournalingUserMySql", userName);
        } else {
            getSqlMapClientTemplate().update("setJournalingUser", userName);
        }
        log("setJournalingUser", userName, null);
    }

    /*=================================================================================================================
     * VSCD
     */
    public List<VSCD> findAllVSCDs() {
        List<VSCD> result = (List<VSCD>) getSqlMapClientTemplate().queryForList("findAllVSCDs");
        log("findAllVSCDs", null, result);
        return result;
    }

    public List<VSCD> findAllSearchVSCDs(String search) {
        List<VSCD> result = (List<VSCD>) getSqlMapClientTemplate().queryForList("findAllSearchVSCDs", search);
        log("findAllSearchVSCDs", search, result);
        return result;
    }

    public void insertVSCD(VSCD vscd) {
        Long id = (Long) getSqlMapClientTemplate().insert("insertVSCD", vscd);
        vscd.setId(id);
        log("insertVSCD", vscd, null);
    }

    public void updateVSCD(VSCD vscd) {
        getSqlMapClientTemplate().update("updateVSCD", vscd);
        log("updateVSCD", vscd, null);
    }

    public void deleteVSCD(VSCD vscd) {
        getSqlMapClientTemplate().delete("deleteVSCD", vscd);
        log("deleteVSCD", vscd, null);
    }

    public List<Contact> findAllContacts() {
        List<Contact> result = (List<Contact>) getSqlMapClientTemplate().queryForList("findAllContacts");
        log("findAllContacts", null, result);
        return result;
    }

    public List<Contact> findAllVSCDContacts(VSCD vscd) {
        List<Contact> result = (List<Contact>) getSqlMapClientTemplate().queryForList("findAllVSCDContacts", vscd.getId());
        log("findAllContacts", vscd.getId(), result);
        return result;
    }

    public void insertContact(Contact contact) {
        Long id = (Long) getSqlMapClientTemplate().insert("insertContact", contact);
        contact.setId(id);
        log("insertContact", contact, null);
    }

    public void updateContact(Contact contact) {
        getSqlMapClientTemplate().update("updateContact", contact);
        log("updateContact", contact, null);
    }

    public void deleteContact(Contact contact) {
        getSqlMapClientTemplate().delete("deleteContact", contact);
        log("deleteContact", contact, null);
    }

    /*=================================================================================================================
     * Action
     */
    public void insertAction(Action action) {
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            getSqlMapClientTemplate().insert("insertActionMySql", action);
        } else {
            getSqlMapClientTemplate().insert("insertAction", action);
        }
        log("insertAction", action, null);
    }

    /*=================================================================================================================
     * Connection
     */
    public List<Connection> findAllConnections() {
        List<Connection> result;
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            result = (List<Connection>) getSqlMapClientTemplate().queryForList("findAllConnectionsMySql");
        } else {
            result = (List<Connection>) getSqlMapClientTemplate().queryForList("findAllConnections");
        }
            log("findAllConnections", null, result);
        return result;
    }

    public List<Connection> findConnectionsForQueryAndUser(Query query, User user) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("query_id", query.getId());
        params.put("user_id", user.getId());
        List<Connection> result;
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            result = (List<Connection>) getSqlMapClientTemplate().queryForList("findConnectionsForQueryAndUserMySql", params);
        } else {
            result = (List<Connection>) getSqlMapClientTemplate().queryForList("findConnectionsForQueryAndUser", params);
        }
        log("findConnectionsForQueryAndUser", params, result);
        return result;
    }

    public Connection getConnectionByName(String name) {
        Connection result;
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            result = (Connection) getSqlMapClientTemplate().queryForObject("getConnectionByNameMySql", name);
        } else {
           result = (Connection) getSqlMapClientTemplate().queryForObject("getConnectionByName", name);
        }
        log("getConnectionByName", name, result);
        return result;
    }

    public void insertConnection(Connection connection) {
        Long id;
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            id = (Long) getSqlMapClientTemplate().insert("insertConnectionMySql", connection);
        } else {
            id = (Long) getSqlMapClientTemplate().insert("insertConnection", connection);
        }
        connection.setId(id);
        log("insertConnection", connection, null);
    }

    public void updateConnection(Connection connection) {
        getSqlMapClientTemplate().update("updateConnection", connection);
        log("updateConnection", connection, null);
    }

    public void deleteConnection(Connection connection) {
        getSqlMapClientTemplate().delete("deleteConnection", connection);
        log("deleteConnection", connection, null);
    }

    /*=================================================================================================================
     * Login
     */
    public void insertLogin(Login login) {
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            getSqlMapClientTemplate().insert("insertLoginMySql", login);
        } else {
            getSqlMapClientTemplate().insert("insertLogin", login);
        }
        log("insertLogin", login, null);
    }

    /*=================================================================================================================
     * Menu
     */
    public void insertMenu(Menu menu) {
        getSqlMapClientTemplate().insert("insertMenu", menu);
        log("insertMenu", menu, null);
    }

    /*=================================================================================================================
    * MenuNode
    */
    public List<MenuNode> findAllMenuNodes() {
        List<MenuNode> result = (List<MenuNode>) getSqlMapClientTemplate().queryForList("findAllMenuNodes");
        log("findAllMenuNodes", null, result);
        return result;
    }

    public List<MenuNode> findAllMenuNodesOrderByDisplay() {
        List<MenuNode> result = (List<MenuNode>) getSqlMapClientTemplate().queryForList("findAllMenuNodesOrderByDisplay");
        log("findAllMenuNodesOrderByDisplay", null, result);
        return result;
    }

    public void insertMenuNode(MenuNode menuNode) {
        Long id;
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            id = (Long) getSqlMapClientTemplate().insert("insertMenuNodeMySql", menuNode);
        } else {
            id = (Long) getSqlMapClientTemplate().insert("insertMenuNode", menuNode);
        }
        menuNode.setId(id);
        log("insertMenuNode", menuNode, null);
    }

    public void updateMenuNode(MenuNode menuNode) {
        getSqlMapClientTemplate().update("updateMenuNode", menuNode);
        log("updateMenuNode", menuNode, null);
    }

    public void deleteMenuNode(MenuNode menuNode) {
        getSqlMapClientTemplate().delete("deleteMenuNode", menuNode);
        log("deleteMenuNode", menuNode, null);
    }

    /*=================================================================================================================
     * Permission
     */
    public List<Permission> findAllPermissions() {
        List<Permission> result = (List<Permission>) getSqlMapClientTemplate().queryForList("findAllPermissions");
        log("findAllPermissions", null, result);
        return result;
    }

    public List<Permission> findAllSearchPermissions(String search) {
        List<Permission> result;
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
             result = (List<Permission>) getSqlMapClientTemplate().queryForList("findAllSearchPermissionsMySql", search);
        } else {
            result = (List<Permission>) getSqlMapClientTemplate().queryForList("findAllSearchPermissions", search);
        }
        log("findAllSearchPermissions", search, result);
        return result;
    }

    public List<Permission> findPermissionsByRole(Role role) {
        List<Permission> result = (List<Permission>) getSqlMapClientTemplate().queryForList("findPermissionsByRole", role.getId());
        log("findPermissionsByRole", role.getId(), result);
        return result;
    }

    public List<Permission> findPermissionsByUser(User user) {
        List<Permission> result = (List<Permission>) getSqlMapClientTemplate().queryForList("findPermissionsByUser", user.getId());
        log("findPermissionsByUser", user.getId(), result);
        return result;
    }

    public Permission getPermissionByName(String name) {
        Permission result = (Permission) getSqlMapClientTemplate().queryForObject("getPermissionByName", name);
        log("getPermissionByName", name, result);
        return result;
    }

    public void insertPermission(Permission permission) {
        Long id;
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            id = (Long) getSqlMapClientTemplate().insert("insertPermissionMySql", permission);
        } else {
            id = (Long) getSqlMapClientTemplate().insert("insertPermission", permission);
        }
        permission.setId(id);
        log("insertPermission", permission, null);
    }

    public void updatePermission(Permission permission) {
        getSqlMapClientTemplate().update("updatePermission", permission);
        log("updatePermission", permission, null);
    }

    public void deletePermission(Permission permission) {
        getSqlMapClientTemplate().delete("deletePermission", permission);
        log("deletePermission", permission, null);
    }

    public List<UrlLink> findUrlLinks(User user, String menu) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("username", user.getName());
        params.put("urlmenuname", menu);
        List<UrlLink> result = (List<UrlLink>) getSqlMapClientTemplate().queryForList("findUrlLinks", params);
        log("findUrlLinks", params, result);
        return result;
    }

    /*=================================================================================================================
     * ReportConnection
     */
    public List<ReportConnection> findAllReportConnections() {
        List<ReportConnection> result = (List<ReportConnection>) getSqlMapClientTemplate().queryForList("findAllReportConnections");
        log("findAllReportConnections", null, result);
        return result;
    }

    public ReportConnection getReportConnectionByName(String name) {
        ReportConnection result = (ReportConnection) getSqlMapClientTemplate().queryForObject("getReportConnectionByName", name);
        log("getReportConnectionByName", name, result);
        return result;
    }

    public void insertReportConnection(ReportConnection reportconnection) {
        Long id = (Long) getSqlMapClientTemplate().insert("insertReportConnection", reportconnection);
        reportconnection.setId(id);
        log("insertReportConnection", reportconnection, null);
    }

    public void updateReportConnection(ReportConnection reportconnection) {
        getSqlMapClientTemplate().update("updateReportConnection", reportconnection);
        log("updateReportConnection", reportconnection, null);
    }

    public void deleteReportConnection(ReportConnection reportconnection) {
        getSqlMapClientTemplate().delete("deleteReportConnection", reportconnection);
        log("deleteReportConnection", reportconnection, null);
    }

    /*=================================================================================================================
    * Query
    */
    public List<Query> findAllQueries() {
        List<Query> result = (List<Query>) getSqlMapClientTemplate().queryForList("findAllQueries");
        log("findAllQueries", null, result);
        return result;
    }

    public List<Query> findAllSearchQueries(String search) {
        List<Query> result = (List<Query>) getSqlMapClientTemplate().queryForList("findAllSearchQueries", search);
        log("findAllQueries", search, result);
        return result;
    }

    public List<Query> findAllQueriesOrderByRecent() {
        List<Query> result = (List<Query>) getSqlMapClientTemplate().queryForList("findAllQueriesOrderByRecent");
        log("findAllQueriesOrderByRecent", null, result);
        return result;
    }

    public Query getQueryByName(String name) {
        Query result = (Query) getSqlMapClientTemplate().queryForObject("getQueryByName", name);
        log("getQueryByName", name, result);
        return result;
    }

    public void insertQuery(Query query) {
        Long id;
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            id = (Long) getSqlMapClientTemplate().insert("insertQueryMySql", query);
        } else {
            id = (Long) getSqlMapClientTemplate().insert("insertQuery", query);
        }
        query.setId(id);
        log("insertQuery", query, null);
    }

    public void updateQuery(Query query) {
        getSqlMapClientTemplate().update("updateQuery", query);
        log("updateQuery", query, null);
    }

    public void deleteQuery(Query query) {
        getSqlMapClientTemplate().delete("deleteQuery", query);
        log("deleteQuery", query, null);
    }

    public List<Query> findReports(User user, String reportName) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("username", user.getName());
        params.put("reportname", reportName);
        List<Query> result = (List<Query>) getSqlMapClientTemplate().queryForList("findReports", params);
        log("findReports", params, result);
        return result;
    }

    /*=================================================================================================================
     * Role
     */
    public List<Link> getRolePermissionLinks(Role role) {
        List<Link> result = (List<Link>) getSqlMapClientTemplate().queryForList("getRolePermissionLinks", role);
        log("getRolePermissionLinks", role, result);
        return result;
    }

    public void insertRolePermission(Link link) {
        Long id;
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            id = (Long) getSqlMapClientTemplate().insert("insertRolePermissionMySql", link);
        } else {
            id = (Long) getSqlMapClientTemplate().insert("insertRolePermission", link);
        }
        link.setId(id);
        log("insertRolePermission", link, null);
    }

    public void deleteRolePermissionLinks(Role role) {
        getSqlMapClientTemplate().delete("deleteRolePermissionLinks", role);
        log("deleteRolePermissionLinks", role, null);
    }

    public List<Role> findAllRoles() {
        List<Role> result = (List<Role>) getSqlMapClientTemplate().queryForList("findAllRoles");
        log("findAllRoles", null, result);
        return result;
    }

    public List<Role> findAllSearchRoles(String search) {
        List<Role> result = (List<Role>) getSqlMapClientTemplate().queryForList("findAllSearchRoles", search);
        log("findAllRoles", search, result);
        return result;
    }

    public List<Role> findAllRolesOfType(String roleName) {
        List<Role> result = (List<Role>) getSqlMapClientTemplate().queryForList("findAllRolesOfType", roleName);
        log("findAllRolesOfType", roleName, result);
        return result;
    }

    public List<Role> findRolesByUser(Long userId) {
        List<Role> result = (List<Role>) getSqlMapClientTemplate().queryForList("findRolesByUser", userId);
        log("findRolesByUser", userId, result);
        return result;
    }

    public void insertRole(Role role) {
        Long id;
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            id = (Long) getSqlMapClientTemplate().insert("insertRoleMySql", role);
        } else {
            id = (Long) getSqlMapClientTemplate().insert("insertRole", role);
        }
        role.setId(id);
        log("insertRole", role, null);
    }

    public void updateRole(Role role) {
        getSqlMapClientTemplate().update("updateRole", role);
        log("updateRole", role, null);
    }

    public void deleteRole(Role role) {
        getSqlMapClientTemplate().delete("deleteRole", role);
        log("deleteRole", role, null);
    }

    /*=================================================================================================================
     * User
     */
    public List<User> findAllUsers() {
        List<User> result = (List<User>) getSqlMapClientTemplate().queryForList("findAllUsers");
        log("findAllUsers", null, result);
        return result;
    }

    public List<User> findAllSearchUsers(String search) {
        List<User> result = (List<User>) getSqlMapClientTemplate().queryForList("findAllSearchUsers", search);
        log("findAllSearchUsers", search, result);
        return result;
    }

    public User getUserByName(String name) {
        User result = (User) getSqlMapClientTemplate().queryForObject("getUserByName", name);
        log("getUserByName", name, result);
        return result;
    }

    public User getUserByIdmId(String idmId) {
        User result = (User) getSqlMapClientTemplate().queryForObject("getUserByIdmId", idmId);
        log("getUserByIdmId", idmId, result);
        return result;
    }

    public List<Link> getUserRoleLinks(User user) {
        List<Link> result = (List<Link>) getSqlMapClientTemplate().queryForList("getUserRoleLinks", user);
        log("getUserRoleLinks", user, result);
        return result;
    }

    public void insertUserRole(Link link) {
        Long id;
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            id = (Long) getSqlMapClientTemplate().insert("insertUserRoleMySql", link);
        } else {
            id = (Long) getSqlMapClientTemplate().insert("insertUserRole", link);
        }
        link.setId(id);
        log("insertUserRole", link, null);
    }

    public void deleteUserRoleLinks(User user) {
        getSqlMapClientTemplate().delete("deleteUserRoleLinks", user);
        log("deleteUserRoleLinks", user, null);
    }

    public List<User> findUsersByRole(Role role) {
        List<User> result = (List<User>) getSqlMapClientTemplate().queryForList("findUsersByRole", role);
        log("findUsersByRole", role, result);
        return result;
    }

    public Integer checkCurrentPassword(User user) {
        Integer result = (Integer) getSqlMapClientTemplate().queryForObject("checkCurrentPassword", user);
        log("checkCurrentPassword", user, result);
        return result;
    }

    public Integer checkPasswordChanged(User user) {
        Integer result = (Integer) getSqlMapClientTemplate().queryForObject("checkPasswordChanged", user);
        log("checkPasswordChanged", user, result);
        return result;
    }

    public void changePassword(User user) {
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
                getSqlMapClientTemplate().update("changePasswordMySql", user);
        } else {
            getSqlMapClientTemplate().update("changePassword", user);
        }
        log("changePassword", user, null);
    }

    public String hashPassword(String pwd) {
        String result = (String) getSqlMapClientTemplate().queryForObject("hashPassword", pwd);
        log("hashPassword", "PWD", result);
        return result;
    }

    public Long getUserIdByUserNamePassword(User user) {
        Long result;
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            result = (Long) getSqlMapClientTemplate().queryForObject("getUserIdByUserNamePasswordMySql", user);
        } else {
            result = (Long) getSqlMapClientTemplate().queryForObject("getUserIdByUserNamePassword", user);
        }
        log("getUserIdByUserNamePassword", user, result);
        return result;
    }

    public void insertUser(User user) {
        Long id;
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            id = (Long) getSqlMapClientTemplate().insert("insertUserMySql", user);
        } else {
            id = (Long) getSqlMapClientTemplate().insert("insertUser", user);
        }
        user.setId(id);
        log("insertUser", user, null);
    }

    public void updateUser(User user) {
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            getSqlMapClientTemplate().update("updateUserMySql", user);
        } else {
            getSqlMapClientTemplate().update("updateUser", user);
        }
        log("updateUser", user, null);
    }

    public void deleteUser(User user) {
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            getSqlMapClientTemplate().delete("deleteUserMySql", user);
        } else {
            getSqlMapClientTemplate().delete("deleteUser", user);
        }
        log("deleteUser", user, null);
    }

    public List<UserMenu> findUserMenus(Long userId) {
        List<UserMenu> result;
        if (config.getProperty("DATABASE_TYPE").equals("mysql")) {
            result = (List<UserMenu>) getSqlMapClientTemplate().queryForList("findUserMenusMySql", userId);
        } else {
            result = (List<UserMenu>) getSqlMapClientTemplate().queryForList("findUserMenus", userId);
        }
        log("findUserMenus", userId, result);
        return result;
    }

    private void log(String statementName, Object params, Object result) {
        if (logger.isDebugEnabled()) {
            StringBuilder sb = new StringBuilder();

            if (statementName != null) {
                sb.append("\nStatement: " + statementName);
            }
            if (params != null) {
                sb.append("\nParameters: ");
                if (params instanceof Map) {
                    for (Map.Entry<String, Object> entry : ((Map<String, Object>) params).entrySet()) {
                        sb.append("\n   " + entry.getKey() + " = " + entry.getValue());
                    }
                } else {
                    sb.append("   " + params);
                }
            }
            if (result != null) {
                sb.append("\nResult: ");
                if (result instanceof List) {
                    List resultList = (List) result;
                    sb.append("\n   list size: " + resultList.size());
                    for (Object obj : resultList) {
                        sb.append("\n   object: " + obj);
                    }
                } else {
                    sb.append("\n   " + result);
                }
            }

            logger.debug(sb.toString());
        }
    }
}
