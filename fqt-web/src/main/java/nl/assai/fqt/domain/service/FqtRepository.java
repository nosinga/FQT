package nl.assai.fqt.domain.service;

import nl.assai.fqt.domain.model.fqt.*;

import java.util.List;

public interface FqtRepository {
    // VSCD
    List<VSCD> findAllVSCDs();
    List<VSCD> findAllSearchVSCDs(String search);
    void insertVSCD(VSCD vscd);
    void updateVSCD(VSCD vscd);
    void deleteVSCD(VSCD vscd);

    // Contact
    List<Contact> findAllContacts();
    List<Contact> findAllVSCDContacts(VSCD vscd);
    void insertContact(Contact contact);
    void updateContact(Contact contact);
    void deleteContact(Contact contact);

    // Action
    void insertAction(Action action);

    // Connection
    List<Connection> findAllConnections();
    List<Connection> findConnectionsForQueryAndUser(Query query, User user);
    Connection getConnectionByName(String name);
    void insertConnection(Connection connection);
    void updateConnection(Connection connection);
    void deleteConnection(Connection connection);

    // Login
    void insertLogin(Login login);

    // Menu
    void insertMenu(Menu menu);

    // MenuNode
    List<MenuNode> findAllMenuNodes();
    List<MenuNode> findAllMenuNodesOrderByDisplay();
    List<MenuNode> findPossibleParentMenuNodes(MenuNode currentNode);
    void insertMenuNode(MenuNode menuNode);
    void updateMenuNode(MenuNode menuNode);
    void deleteMenuNode(MenuNode menuNode);

    // Permission
    List<Permission> findAllPermissions();
    List<Permission> findAllSearchPermissions(String search);
    List<Permission> findPermissionsByRole(Role role);
    List<Permission> findPermissionsByUser(User user);
    Permission getPermissionByName(String name);
    void insertPermission(Permission permission);
    void updatePermission(Permission permission);
    void deletePermission(Permission permission);
    List<UrlLink> findUrlLinks(User user, String menu);

    // ReportConnections
    List<ReportConnection> findAllReportConnections();
    ReportConnection getReportConnectionByName(String name);
    void insertReportConnection(ReportConnection reportconnection);
    void updateReportConnection(ReportConnection reportconnection);
    void deleteReportConnection(ReportConnection reportconnection);

    // Query
    List<Query> findAllQueries();
    List<Query> findAllSearchQueries(String search);
    List<Query> findAllQueriesOrderByRecent();
    Query getQueryByName(String name);
    void insertQuery(Query query);
    void updateQuery(Query query);
    void deleteQuery(Query query);
    List<Query> findReports(User user, String reportName);

    // Role
    List<Link> getRolePermissionLinks(Role role);
    void insertRolePermission(Link link);
    void deleteRolePermissionLinks(Role role);
    List<Role> findAllRoles();
    List<Role> findAllSearchRoles(String search);
    List<Role> findAllRolesOfType(String roleName);
    List<Role> findRolesByUser(Long userId);
    void insertRole(Role role);
    void updateRole(Role role);
    void deleteRole(Role role);

    // User
    List<User> findAllUsers();
    List<User> findAllSearchUsers(String search);
    User getUserByName(String name);
    User getUserByIdmId(String idmId);
    List<Link> getUserRoleLinks(User user);
    void insertUserRole(Link link);
    void deleteUserRoleLinks(User user);
    List<User> findUsersByRole(Role role);
    Integer checkCurrentPassword(User user);
    Integer checkPasswordChanged(User user);
    void changePassword(User user);
    String hashPassword(String pwd);
    Long getUserIdByUserNamePassword(User user);
    void insertUser(User user);
    void updateUser(User user);
    void deleteUser(User user);
    List<UserMenu> findUserMenus(Long userId);
    void updateUserRoles(User user);

}
